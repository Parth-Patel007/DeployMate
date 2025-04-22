import React, { useEffect, useState } from 'react';
import TaskForm from './TaskForm';
import TaskList from './TaskList';
import LogPanel from './LogPanel';
import api from './api';

function App() {
    const [tasks, setTasks] = useState([]);
    const [logs, setLogs] = useState(() => {
        // ✅ Load logs from localStorage on first render
        const saved = localStorage.getItem('deploymate_logs');
        return saved ? JSON.parse(saved) : [];
    });
    const [selectedStatus, setSelectedStatus] = useState('ALL');

    // ✅ Save logs to localStorage whenever they change
    useEffect(() => {
        localStorage.setItem('deploymate_logs', JSON.stringify(logs));
    }, [logs]);

    const addLog = (message) => {
        const timestamp = new Date().toLocaleString();
        setLogs(prev => [{ message, timestamp }, ...prev.slice(0, 9)]);
    };

    const fetchTasks = async () => {
        try {
            const res = await api.get("/tasks");
            setTasks(res.data);
        } catch (err) {
            console.error("Error fetching tasks:", err);
        }
    };

    const handleCreateTask = async (task) => {
        const res = await api.post("/tasks", task);
        setTasks(prev => [res.data, ...prev]);
        addLog(`🆕 Created task "${res.data.title}"`);
    };

    const handleUpdateTask = async (id, updatedTask) => {
        const res = await api.put(`/tasks/${id}`, updatedTask);
        setTasks(prev => prev.map(task => (task.id === id ? res.data : task)));
        addLog(`✏️ Updated task "${res.data.title}"`);
    };

    const handleDeleteTask = async (id) => {
        await api.delete(`/tasks/${id}`);
        setTasks(prev => prev.filter(task => task.id !== id));
        addLog(`🗑️ Deleted task with ID ${id}`);
    };

    useEffect(() => {
        fetchTasks();
    }, []);

    const filteredTasks = selectedStatus === 'ALL'
        ? tasks
        : tasks.filter(task => task.status === selectedStatus);

    return (
        <div className="min-h-screen bg-blue-50 p-6 text-gray-800">
            <h1 className="text-3xl font-bold text-blue-700 mb-6">📋 DeployMate Dashboard</h1>

            <div className="flex flex-col lg:flex-row gap-6">
                <div className="flex-1 space-y-6">
                    <TaskForm onCreate={handleCreateTask} />

                    <div>
                        <div className="flex items-center justify-between mb-2">
                            <h2 className="text-xl font-semibold text-blue-700">Tasks</h2>
                            <select
                                value={selectedStatus}
                                onChange={(e) => setSelectedStatus(e.target.value)}
                                className="border rounded-md px-3 py-2 text-sm"
                            >
                                <option value="ALL">All</option>
                                <option value="NEW">NEW</option>
                                <option value="RUNNING">RUNNING</option>
                                <option value="DONE">DONE</option>
                            </select>
                        </div>

                        <TaskList
                            tasks={filteredTasks}
                            onDelete={handleDeleteTask}
                            onUpdate={handleUpdateTask}
                        />
                    </div>
                </div>

                <div className="w-full lg:w-1/3">
                    <LogPanel logs={logs} />
                </div>
            </div>
        </div>
    );
}

export default App;
