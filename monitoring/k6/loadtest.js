import http from 'k6/http';
import { check, sleep } from 'k6';

// ─────────────────────────────────────────────
// Test options: 10 virtual users for 30 seconds
// Fails if 95-th percentile latency ≥ 500 ms
//            or error-rate ≥ 1 %
// ─────────────────────────────────────────────
export const options = {
    vus: 10,
    duration: '30s',
    thresholds: {
        http_req_duration: ['p(95)<500'], // 95 % < 500 ms
        http_req_failed:   ['rate<0.01'], // < 1 % errors
    },
};

// Base URL comes from env var; falls back to local dev
const BASE = __ENV.BASE_URL || 'http://localhost:8080';

export default function () {
    // 1) Quick health check
    const health = http.get(`${BASE}/healthz`);
    check(health, { 'health 200': (r) => r.status === 200 });

    // 2) List tasks
    const list = http.get(`${BASE}/api/tasks`);
    check(list, { 'tasks 200': (r) => r.status === 200 });

    sleep(1);                    // think-time so we hit ~10 RPS total
}
