// src/components/LogPanel.jsx
import React from 'react';
import { ActivitySquare } from "lucide-react";

function LogPanel({ logs }) {
    return (
        <div className="bg-white shadow p-4 rounded w-full lg:w-1/3">
            <h2 className="text-lg font-semibold mb-2 flex items-center gap-2">
                <ActivitySquare className="text-blue-600" /> Activity Log
            </h2>
            <ul className="text-sm space-y-1">
                {logs.length === 0 ? (
                    <li className="text-gray-400">No activity yet.</li>
                ) : (
                    logs.map((log, index) => (
                        <li key={index}>
                            <span className="text-gray-700">{log.message}</span>
                            <span className="text-gray-400 text-xs block">{log.timestamp}</span>
                        </li>
                    ))
                )}
            </ul>
        </div>
    );
}

export default LogPanel;
