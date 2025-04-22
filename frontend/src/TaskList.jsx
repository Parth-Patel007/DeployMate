import React, { useState } from 'react';

const statusColors = {
    NEW: 'bg-gray-200 text-gray-800',
    RUNNING: 'bg-blue-200 text-blue-800',
    DONE: 'bg-green-200 text-green-800',
};

function TaskList({ tasks, onDelete, onUpdate }) {
    const [editId, setEditId] = useState(null);
    const [editData, setEditData] = useState({});

    const handleEditClick = (task) => {
        setEditId(task.id);
        setEditData({ ...task });
    };

    const handleChange = (e) => {
        setEditData({ ...editData, [e.target.name]: e.target.value });
    };

    const handleSubmit = () => {
        onUpdate(editId, editData);
        setEditId(null);
    };

    const handleDelete = (id) => {
        if (window.confirm("Are you sure you want to delete this task?")) {
            onDelete(id);
        }
    };

    return (
        <div className="grid md:grid-cols-2 gap-4">
            {tasks.map((task) => (
                <div key={task.id} className="bg-white p-5 rounded-2xl shadow-md border border-blue-100">
                    {editId === task.id ? (
                        <div className="space-y-2">
                            <input
                                name="title"
                                value={editData.title}
                                onChange={handleChange}
                                className="w-full p-2 border rounded-md"
                            />

                            <select
                                name="type"
                                value={editData.type}
                                onChange={handleChange}
                                className="w-full p-2 border rounded-md"
                            >
                                <option value="">Select Type</option>
                                <option value="BUILD">BUILD</option>
                                <option value="DEPLOY">DEPLOY</option>
                                <option value="TEST">TEST</option>
                            </select>

                            <select
                                name="status"
                                value={editData.status}
                                onChange={handleChange}
                                className="w-full p-2 border rounded-md"
                            >
                                <option value="">Select Status</option>
                                <option value="NEW">NEW</option>
                                <option value="RUNNING">RUNNING</option>
                                <option value="DONE">DONE</option>
                            </select>

                            <input
                                name="assignedTo"
                                value={editData.assignedTo}
                                onChange={handleChange}
                                className="w-full p-2 border rounded-md"
                            />

                            <div className="flex gap-2 mt-2">
                                <button onClick={handleSubmit} className="bg-green-600 text-white px-4 py-1 rounded">Save</button>
                                <button onClick={() => setEditId(null)} className="bg-gray-400 text-white px-4 py-1 rounded">Cancel</button>
                            </div>
                        </div>
                    ) : (
                        <div className="space-y-1">
                            <div className="flex justify-between items-center">
                                <h3 className="text-lg font-semibold text-blue-800">{task.title}</h3>
                                <span className={`text-xs px-2 py-1 rounded-full ${statusColors[task.status] || 'bg-gray-100 text-gray-800'}`}>
                  {task.status}
                </span>
                            </div>
                            <p className="text-sm text-gray-600">Assigned To: <span className="font-medium">{task.assignedTo}</span></p>
                            <p className="text-sm text-gray-500 italic">Type: {task.type}</p>

                            <div className="flex gap-2 mt-3">
                                <button onClick={() => handleEditClick(task)} className="text-sm px-3 py-1 border border-blue-500 text-blue-600 rounded hover:bg-blue-50">Edit</button>
                                <button onClick={() => handleDelete(task.id)} className="text-sm px-3 py-1 border border-red-500 text-red-600 rounded hover:bg-red-50">Delete</button>
                            </div>
                        </div>
                    )}
                </div>
            ))}
        </div>
    );
}

export default TaskList;
