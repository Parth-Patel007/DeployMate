import React, { useState } from 'react';

function TaskForm({ onCreate }) {
    const [formData, setFormData] = useState({
        title: '',
        type: '',
        status: '',
        assignedTo: ''
    });

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        await onCreate(formData);
        setFormData({ title: '', type: '', status: '', assignedTo: '' });
    };

    return (
        <form onSubmit={handleSubmit} className="bg-white p-6 rounded-2xl shadow-md border border-blue-100 mb-6 space-y-4 max-w-xl">
            <h2 className="text-xl font-semibold text-blue-800">➕ Create a New Task</h2>

            <input
                name="title"
                value={formData.title}
                onChange={handleChange}
                placeholder="Title"
                className="w-full px-3 py-2 border rounded-md focus:ring-2 focus:ring-blue-300 outline-none"
                required
            />

            <select
                name="type"
                value={formData.type}
                onChange={handleChange}
                className="w-full px-3 py-2 border rounded-md focus:ring-2 focus:ring-blue-300 outline-none"
                required
            >
                <option value="">Select Type</option>
                <option value="BUILD">BUILD</option>
                <option value="DEPLOY">DEPLOY</option>
                <option value="TEST">TEST</option>
            </select>

            <select
                name="status"
                value={formData.status}
                onChange={handleChange}
                className="w-full px-3 py-2 border rounded-md focus:ring-2 focus:ring-blue-300 outline-none"
                required
            >
                <option value="">Select Status</option>
                <option value="NEW">NEW</option>
                <option value="RUNNING">RUNNING</option>
                <option value="DONE">DONE</option>
            </select>

            <input
                name="assignedTo"
                value={formData.assignedTo}
                onChange={handleChange}
                placeholder="Assigned To"
                className="w-full px-3 py-2 border rounded-md focus:ring-2 focus:ring-blue-300 outline-none"
                required
            />

            <div className="text-right">
                <button
                    type="submit"
                    className="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-4 py-2 rounded-md shadow-sm"
                >
                    Create Task
                </button>
            </div>
        </form>
    );
}

export default TaskForm;
