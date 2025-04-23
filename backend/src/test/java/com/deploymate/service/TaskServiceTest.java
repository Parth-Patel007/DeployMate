import com.deploymate.backend.model.Task;
import com.deploymate.backend.repository.TaskRepository;
import com.deploymate.backend.service.TaskService;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.List;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;

public class TaskServiceTest {

    @Test
    void testGetAllTasksReturnsEmptyList() {
        TaskRepository mockRepo = Mockito.mock(TaskRepository.class);
        SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry(); // ✅

        Mockito.when(mockRepo.findAll()).thenReturn(Collections.emptyList());

        TaskService service = new TaskService(mockRepo, meterRegistry);
        List<Task> result = service.getAllTasks();

        assertTrue(result.isEmpty());
    }

    @Test
    void testCreateTaskIncrementsCounter() {
        TaskRepository mockRepo = Mockito.mock(TaskRepository.class);
        SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry(); // ✅

        Task task = new Task();
        task.setTitle("Sample");
        task.setStatus("NEW");
        task.setType("BUILD");
        task.setAssignedTo("Parth");

        Mockito.when(mockRepo.save(Mockito.any(Task.class))).thenReturn(task);

        TaskService service = new TaskService(mockRepo, meterRegistry);
        Task saved = service.createTask(task);

        assertNotNull(saved);
        assertEquals("Sample", saved.getTitle());
    }
}
