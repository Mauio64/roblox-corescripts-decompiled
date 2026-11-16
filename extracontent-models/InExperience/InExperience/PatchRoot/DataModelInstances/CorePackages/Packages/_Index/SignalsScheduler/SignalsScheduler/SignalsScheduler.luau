local flag = false

local v = {}

local function batch(fn)
	if flag then
		fn()

		return
	end

	flag = true
	fn()

	for _, v2 in v do
		v2()
	end

	table.clear(v)
	flag = false
end

local SignalsScheduler = {}
SignalsScheduler.batch = batch

function SignalsScheduler.flush()
	batch(function() end)
end

function SignalsScheduler.schedule(callback)
	table.insert(v, callback)
end

return SignalsScheduler
