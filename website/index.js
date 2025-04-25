const counter = document.querySelector(".Visitor-Counter");
console.log("Counter element:", counter);

async function updateCounter() {
    try {
        const apiUrl = window.apiConfig.apiUrl;  // Fetching the apiUrl from config.js
        let response = await fetch(apiUrl);  // Sending a GET request to the API Gateway URL
        let data = await response.json();  // Parsing the response as JSON

        console.log("API response:", data);

        if (data.visitor_count !== undefined) {
            counter.innerHTML = `🔁 This serverless resume just got another hit — visitor #${data.visitor_count} is you!`;
        } else {
            counter.innerHTML = `⚠️ Couldn't read visitor count.`;
        }

    } catch (error) {
        console.error('Error fetching visitor count:', error);
        counter.innerHTML = `⚠️ Error getting count.`;
    }
}

updateCounter();

