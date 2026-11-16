local PioneerUtils = script:FindFirstAncestor("PioneerUtils")
local parent = PioneerUtils.Parent

local Fetch = require(parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local PioneerLeaveReason = require(PioneerUtils.PioneerLeaveReason)
local isPioneerLaunch = require(PioneerUtils.isPioneerLaunch)
local leaveExperience = require(PioneerUtils.leaveExperience)

local v = string.format("%s/users/authenticated/app-launch-info", Url.USERS_URL)

local function fetchIsConfirmedThirteenPlus()
	return Promise.new(function(callback)
		local expect = fetch(v, { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if not expect.ok then
			callback(false)
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		callback(typeof(expect2) == "table" and typeof(expect2.ageBracket) == "number" and expect2.ageBracket ~= 1)
	end)
end

local function maybeLeavePioneerOnFaeDownAge(flag: boolean, callback)
	local function stay() -- 1 equivalent call inferred from this helper
		if callback then
			callback()
		end
	end

	if isPioneerLaunch() and flag then
		return Promise.new(function(callback2)
			local expect = fetch(v, { method = "GET" }):catch(function()
				return Response.error()
			end):expect()

			if not expect.ok then
				callback2(false)
				return
			end

			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			callback2(typeof(expect2) == "table" and typeof(expect2.ageBracket) == "number" and expect2.ageBracket ~= 1)
		end):andThen(function(p): boolean
			if p then
				stay() -- inferred equivalent call
			else
				leaveExperience(PioneerLeaveReason.AccountUnder13)
			end

			return not p
		end)
	end

	if callback then
		callback()
	end
end

return maybeLeavePioneerOnFaeDownAge
