const counter = document.querySelector(".Visitor-Counter");
console.log("Counter element:", counter);

async function updateCounter() {
    try {
        const apiUrl = window.apiConfig.apiUrl;
        let response = await fetch(apiUrl);
        let data = await response.json();

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

