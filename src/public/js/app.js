function initializeChart() {
    const ctx = document.getElementById('priceChart').getContext('2d');
    const labels = JSON.parse(ctx.canvas.getAttribute('data-labels'));
    const priceData = JSON.parse(ctx.canvas.getAttribute('data-prices'));

    const data = {
        labels: labels,
        datasets: [{
            label: 'Price ($)',
            data: priceData,
            borderColor: 'rgba(75, 192, 192, 1)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderWidth: 2,
            pointRadius: 3,
            spanGaps: true
        }]
    };

    const config = {
        type: 'line',
        data: data,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: true,
                    position: 'top'
                },
                tooltip: {
                    enabled: true
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: "Minutes of the Hour"
                    }
                },
                y: {
                    ticks: {
                        callback: function (value) {
                            return `$${value}`;
                        }
                    },
                    title: {
                        display: true,
                        text: "Price ($)"
                    }
                }
            }
        }
    };

    new Chart(ctx, config);
}

async function triggerScrape() {
    try {
        const response = await fetch('/scrape', { method: 'POST' });
        if (response.ok) {
            console.log('scrape triggered successfully!');
            location.reload();
        } else {
            console.error('scrape execution failed:', response);
        }
    } catch (error) {
        console.error('scrape execution failed:', error);
    }
}

document.addEventListener('DOMContentLoaded', initializeChart);