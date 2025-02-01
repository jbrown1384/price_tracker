async function triggerScrape() {
    try {
        const response = await fetch('/scrape', { method: 'POST' });
        const result = await response.text();
        console.log('Scrape Triggered:', result);
        location.reload();
    } catch (error) {
        console.error('Error triggering scrape:', error);
        alert('Failed to trigger scrape!');
    }
}
