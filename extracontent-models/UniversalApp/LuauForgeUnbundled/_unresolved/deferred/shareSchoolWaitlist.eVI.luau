local default = require("@luauforge/deferred/eVJ").ExternalContentSharingProtocol.default

local module = require("@luauforge/deferred/eVK")
local module2 = require("@luauforge/deferred/eVn")

local flag = false

local function getSurface(p2)
	if p2 and p2.context then
		return p2.context
	end

	return "SchoolWaitlist"
end

local function shareSchoolWaitlist(data)
	if flag then
		return
	end

	local onShared = if data then data.onShared else nil
	local onError = if data then data.onError else nil
	local isCancelledRef = if data then data.isCancelledRef else nil

	flag = true
	task.spawn(function()
		local v6

		if module2 then
			local v7 = data
			v6 = not (v7 and v7.context) and "SchoolWaitlist" or v7.context
		end

		local v7 = module(v6)

		if isCancelledRef and isCancelledRef.current then
			flag = false
		elseif v7 then
			local success, result = pcall(function()
				local v10

				if module2 then
					local v11 = data
					v10 = not (v11 and v11.context) and "SchoolWaitlist" or v11.context
				else
					v10 = "SchoolWaitlist"
				end

				default:shareUrl({ context = v10, url = v7 })
			end)

			flag = false

			if isCancelledRef and isCancelledRef.current then
				return
			end

			if success then
				if onShared then
					onShared()
				end
			elseif onError then
				onError()
			end
		else
			flag = false

			if onError then
				onError()
			end
		end
	end)
end

return shareSchoolWaitlist
