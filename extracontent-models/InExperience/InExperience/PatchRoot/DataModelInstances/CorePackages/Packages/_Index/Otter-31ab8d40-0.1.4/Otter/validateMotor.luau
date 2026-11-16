local function validateMotor(data)
	assert(typeof(data) == "table")
	assert(typeof(data.start) == "function")
	assert(typeof(data.stop) == "function")
	assert(typeof(data.step) == "function")
	assert(typeof(data.setGoal) == "function")
	assert(typeof(data.onStep) == "function")
	assert(typeof(data.onComplete) == "function")
	assert(typeof(data.destroy) == "function")
end

return validateMotor
