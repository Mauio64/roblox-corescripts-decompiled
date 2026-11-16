local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.LuauPolyfill)
local Promise = require(parent.Promise)

local v = {}
local flag = false
local count = 0
local fn

local function completeRequest() -- 2 equivalent calls inferred from this helper
	flag = false
	fn()
end

fn = function()
	if flag then
		return
	end

	local v2 = table.remove(v, 1)

	while v2 and v2.owner.cancelled do
		v2.resolve(nil)
		v2 = table.remove(v, 1)
	end

	if not v2 then
		return
	end

	flag = true

	local function fn2(p)
		v2.resolve(p)
		completeRequest() -- inferred equivalent call
	end

	local function fn3(p)
		v2.reject(p)
		completeRequest() -- inferred equivalent call
	end

	Promise.try(v2.request):andThen(fn2, fn3)
end

local ChatModerationStatusRefreshCoordinator = {}

function ChatModerationStatusRefreshCoordinator.createOwner()
	return { cancelled = false }
end

function ChatModerationStatusRefreshCoordinator.cancelOwner(p)
	p.cancelled = true
end
function ChatModerationStatusRefreshCoordinator.enqueue(owner, request)
	count += 1

	return {
		generation = count,
		promise = Promise.new(function(resolve, reject)
			table.insert(v, { owner = owner, request = request, resolve = resolve, reject = reject })

			fn()
		end)
	}
end

function ChatModerationStatusRefreshCoordinator.isLatestGeneration(p: number): boolean
	return p == count
end

return ChatModerationStatusRefreshCoordinator
