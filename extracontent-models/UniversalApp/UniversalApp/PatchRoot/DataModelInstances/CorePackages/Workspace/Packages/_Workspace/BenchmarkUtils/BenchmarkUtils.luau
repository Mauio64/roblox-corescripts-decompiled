local benchmarkUtils = require(script.benchmarkUtils)

return {
	benchFile = benchmarkUtils.benchFile,
	measureFPS = benchmarkUtils.measureFPS,
	mountComponentTimes = benchmarkUtils.mountComponentTimes,
	scrollComponentTimes = benchmarkUtils.scrollComponentTimes,
	benchmarkRender = benchmarkUtils.benchmarkRender,
	benchmarkRerender = benchmarkUtils.benchmarkRerender,
	AutoScrollingFrame = benchmarkUtils.AutoScrollingFrame,
	DEFAULT_MOUNT_TIMES = benchmarkUtils.DEFAULT_MOUNT_TIMES,
	DEFAULT_SCROLL_TIMES = benchmarkUtils.DEFAULT_SCROLL_TIMES,
	DEFAULT_FPS_DURATION = benchmarkUtils.DEFAULT_FPS_DURATION
}
