local module = require("@luauforge/bundled/fJy")
local appPage = require("@luauforge/bundled/fJz").AppPage

local module2 = require("@luauforge/bundled/fJT")
local module3 = require("@luauforge/bundled/fJU")

local function getLatestPastTimestamp(unixTimestamp)
	local latestPastTimestamp = nil

	for k, v5 in string.split(module2, ",") do
		local v6 = tonumber((string.gsub(v5, "%s", "")))

		if v6 and v6 <= unixTimestamp and (latestPastTimestamp == nil or latestPastTimestamp < v6) then
			latestPastTimestamp = v6
		end
	end

	return latestPastTimestamp
end

local function shouldShowNewBadge(p2): boolean
	if p2 == nil then
		return false
	elseif p2 == 0 then
		return true
	end

	local latestPastTimestamp = getLatestPastTimestamp(DateTime.now().UnixTimestamp)

	if latestPastTimestamp == nil then
		return false
	end

	return p2 < latestPastTimestamp
end

local function useCampaignTabNewBadge(p2)
	local v5 = module.useState(function()
		return module3.getLastOpened()
	end)
	local v6 = v5 ~= nil
	local state, setState = module.useState(function(): boolean
		local v7 = v5

		if v7 == nil then
			return false
		elseif v7 == 0 then
			return true
		end

		local latestPastTimestamp = getLatestPastTimestamp(DateTime.now().UnixTimestamp)

		if latestPastTimestamp == nil then
			return false
		end

		return v7 < latestPastTimestamp
	end)

	module.useEffect(function()
		if p2 ~= appPage.Campaign or not v6 then
			return
		end

		if module3.setLastOpened(DateTime.now().UnixTimestamp) then
			setState(false)
		end
	end, { p2, v6 })

	return state and p2 ~= appPage.Campaign
end

return useCampaignTabNewBadge
