const counter = document.querySelector(".Visitor-Counter");
console.log("Counter element:", counter);

async function updateCounter() {
    try {
        let response = await fetch("https://3vcvj79nr6.execute-api.ap-southeast-1.amazonaws.com/prod/visitor_count");
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

