## basically prometheus scrape http method metrics to get pull information of API and supplies to grafana to see them as a visual information on how good API is
## 1.`docker compose up -d --build`
## 2.`docker compose down`
## prometheus url http://prometheus:9090 for grafana setup
## Queries such as PromQL
## 1. sum by (endpoint,status) (rate(api_request_total)[1m]) used to tell requests per second multiply with 60 to get req per min
## loop query (bash) `while true;do curl -s http://localhost:5000;sleep 1;done`
# Theory Questions
## 1. What is API monitoring and why is it important in production?

API monitoring is the continuous measurement of an API's availability, performance (latency and throughput), and correctness (error rates) using metrics, logs, and alerts.

### Importance:
1. **Detect Outages:** Identifies API failures and slowdowns before users complain.
2. **Faster Debugging:** Helps teams identify and resolve issues quickly.
3. **SLA and SLO Tracking:** Ensures the API meets performance and reliability targets.
4. **Capacity Planning:** Helps understand traffic trends and plan server resources.
5. **Security Monitoring:** Helps identify suspicious traffic and abuse patterns.

**Note:** Without API monitoring, problems may only be discovered when customers report them.

---

## 2. What do response time and error rate indicate?

1. **Response Time (Latency):** Measures how long an API takes to respond to a request. Increasing response time indicates slow code, overloaded servers, or slow dependencies. It affects user experience and is commonly measured using averages and percentiles such as p95.

2. **Error Rate:** Measures the percentage of requests that fail (usually 5xx errors and sometimes 4xx errors). An increasing error rate indicates bugs, faulty deployments, or failing dependencies.

**Note:** Together, response time and error rate indicate whether an API is performing efficiently and reliably.