package com.deploymate.backend.service;

import com.deploymate.backend.model.Task;
import com.deploymate.backend.repository.TaskRepository;
import org.springframework.stereotype.Service;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Gauge;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Service
public class TaskService {

    private final TaskRepository repo;

    // Counters
    private final Counter taskCreatedCounter;
    private final Counter taskUpdatedCounter;
    private final Counter taskDeletedCounter;

    // Gauges: Live count maps
    private final ConcurrentHashMap<String, AtomicInteger> tasksByType = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, AtomicInteger> tasksByStatus = new ConcurrentHashMap<>();

    public TaskService(TaskRepository repo, MeterRegistry meterRegistry) {
        this.repo = repo;

        // === COUNTERS ===
        this.taskCreatedCounter = Counter.builder("deploymate_tasks_created_total")
                .description("Total tasks created")
                .register(meterRegistry);

        this.taskUpdatedCounter = Counter.builder("deploymate_tasks_updated_total")
                .description("Total tasks updated")
                .register(meterRegistry);

        this.taskDeletedCounter = Counter.builder("deploymate_tasks_deleted_total")
                .description("Total tasks deleted")
                .register(meterRegistry);

        this.taskCreatedCounter.increment(0);
        this.taskUpdatedCounter.increment(0);
        this.taskDeletedCounter.increment(0);

        // === GAUGES ===
        for (String type : List.of("BUILD", "TEST", "DEPLOY", "MONITOR")) {
            tasksByType.put(type, new AtomicInteger(0));
            Gauge.builder("deploymate_tasks_by_type", tasksByType, m -> m.get(type).get())
                    .description("Live count of tasks by type")
                    .tag("type", type)
                    .register(meterRegistry);
        }

        for (String status : List.of("NEW", "RUNNING", "DONE", "FAILED")) {
            tasksByStatus.put(status, new AtomicInteger(0));
            Gauge.builder("deploymate_tasks_by_status", tasksByStatus, m -> m.get(status).get())
                    .description("Live count of tasks by status")
                    .tag("status", status)
                    .register(meterRegistry);
        }

        // Initialize values
        recalculateGauges();
    }

    public List<Task> getAllTasks() {
        return repo.findAll();
    }

    public Task createTask(Task task) {
        task.setCreatedAt(LocalDateTime.now());
        task.setUpdatedAt(LocalDateTime.now());

        Task saved = repo.save(task);

        taskCreatedCounter.increment();
        recalculateGauges();

        return saved;
    }

    public Task updateTask(Long id, Task updatedTask) {
        Task existing = repo.findById(id).orElseThrow(() -> new RuntimeException("Task not found"));
        existing.setTitle(updatedTask.getTitle());
        existing.setType(updatedTask.getType());
        existing.setStatus(updatedTask.getStatus());
        existing.setAssignedTo(updatedTask.getAssignedTo());
        existing.setUpdatedAt(LocalDateTime.now());

        Task updated = repo.save(existing);

        taskUpdatedCounter.increment();
        recalculateGauges();

        return updated;
    }

    public void deleteTask(Long id) {
        repo.deleteById(id);
        taskDeletedCounter.increment();
        recalculateGauges();
    }

    public Task getTaskById(Long id) {
        return repo.findById(id).orElseThrow(() -> new RuntimeException("Task not found"));
    }

    private void recalculateGauges() {
        // Reset all to 0
        tasksByType.values().forEach(counter -> counter.set(0));
        tasksByStatus.values().forEach(counter -> counter.set(0));

        // Recount
        for (Task task : repo.findAll()) {
            if (tasksByType.containsKey(task.getType())) {
                tasksByType.get(task.getType()).incrementAndGet();
            }
            if (tasksByStatus.containsKey(task.getStatus())) {
                tasksByStatus.get(task.getStatus()).incrementAndGet();
            }
        }
    }
}
