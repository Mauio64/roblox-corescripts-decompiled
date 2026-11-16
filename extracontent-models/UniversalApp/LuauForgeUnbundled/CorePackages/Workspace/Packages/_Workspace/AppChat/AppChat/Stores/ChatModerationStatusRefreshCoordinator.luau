require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")

local v5 = {}
local flag = false
local count = 0
local fn

local function completeRequest()
	flag = false
	fn()
end

fn = function()
	if flag then
		return
	end

	local v6 = table.remove(v5, 1)

	while v6 and v6.owner.cancelled do
		v6.resolve(nil)
		v6 = table.remove(v5, 1)
	end

	if not v6 then
		return
	end

	flag = true

	local function fn2(p2)
		v6.resolve(p2)
		flag = false
		fn()
	end

	local function fn3(p2)
		v6.reject(p2)
		flag = false
		fn()
	end

	Promise.try(v6.request):andThen(fn2, fn3)
end

return {
	createOwner = function()
		return { cancelled = false }
	end,
	cancelOwner = function(p2)
		p2.cancelled = true
	end,
	enqueue = function(p2, p3)
		count += 1

		return {
			generation = count,
			promise = Promise.new(function(p4, p5)
				table.insert(v5, { owner = p2, request = p3, resolve = p4, reject = p5 })

				fn()
			end)
		}
	end,
	isLatestGeneration = function(p2): boolean
		return p2 == count
	end
}
