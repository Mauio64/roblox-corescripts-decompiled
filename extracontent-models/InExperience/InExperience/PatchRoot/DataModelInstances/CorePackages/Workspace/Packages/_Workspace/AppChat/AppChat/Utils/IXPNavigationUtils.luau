local IXPService = game:GetService("IXPService")
local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local IXPNavigationUtils = {}

IXPNavigationUtils.ExposureKind = {
	FlagLinked = "FlagLinked",
	BrowserTracker = "BrowserTracker",
	UserLayer = "UserLayer",
	Creator = "Creator"
}

local v = {
	remove = function() end
}

local v2 = {
	[IXPNavigationUtils.ExposureKind.FlagLinked] = "LogFlagLinkedUserLayerExposure",
	[IXPNavigationUtils.ExposureKind.BrowserTracker] = "LogBrowserTrackerLayerExposure",
	[IXPNavigationUtils.ExposureKind.UserLayer] = "LogUserLayerExposure",
	[IXPNavigationUtils.ExposureKind.Creator] = "LogCreatorLayerExposure"
}

local v3 = IXPService

local function normalizeLayers(value) -- 1 equivalent call inferred from this helper
	if type(value) == "string" then
		return { value }
	end

	return value
end

local function isAnyFlagEnabled(items)
	if items == nil then
		return true
	end

	if type(items) == "boolean" then
		return items
	end

	for _, item in items do
		if item then
			return true
		end
	end

	return false
end

local function logExposure(layers, kind)
	local v4 = kind or IXPNavigationUtils.ExposureKind.FlagLinked

	for _, item in layers do
		local v5 = v2[v4]
		local v6

		if v5 then
			v6 = v3[v5]
		end

		if v6 then
			v6(v3, item)
		end
	end
end

function IXPNavigationUtils.createExposureHandler(value, p)
	local layers = normalizeLayers(value) -- inferred equivalent call
	local flags

	if p then
		flags = p.flags
	else
		flags = nil
	end

	local kind

	if p then
		kind = p.kind
	else
		kind = nil
	end

	return function()
		local v4 = flags

		if v4 == nil then
			v4 = true
		elseif type(v4) ~= "boolean" then
			local flag = true

			for _, v5 in v4 do
				if v5 then
					v4 = true
					flag = false
					break
				end
			end

			if flag then
				v4 = false
			end
		end

		if v4 then
			logExposure(layers, kind)
		end
	end
end

function IXPNavigationUtils.useExposureOnFocus(p, p2)
	local v4 = useNavigation()
	local flags

	if p2 then
		flags = p2.flags
	else
		flags = nil
	end

	local kind

	if p2 then
		kind = p2.kind
	else
		kind = nil
	end

	React.useEffect(function()
		if not v4 then
			return nil
		end

		local v5 = flags

		if v5 == nil then
			v5 = true
		elseif type(v5) ~= "boolean" then
			local flag = true

			for _, v6 in v5 do
				if v6 then
					v5 = true
					flag = false
					break
				end
			end

			if flag then
				v5 = false
			end
		end

		if not v5 then
			return nil
		end

		local exposureHandler = IXPNavigationUtils.createExposureHandler(p, {
			flags = flags,
			kind = kind
		})

		local v6 = v4.addListener(RoactNavigation.Events.WillFocus, exposureHandler)

		if v4.isFocused and v4.isFocused() then
			exposureHandler()
		end

		return function()
			v6.remove()
		end
	end, { v4, p, flags, kind })
end

function IXPNavigationUtils.registerExposureOnFocus(p, p2, p3)
	if not p then
		return v
	end

	local v4

	if p3 then
		v4 = p3.flags
	end

	if v4 == nil then
		v4 = true
	elseif type(v4) ~= "boolean" then
		local flag = true

		for _, v5 in v4 do
			if v5 then
				v4 = true
				flag = false
				break
			end
		end

		if flag then
			v4 = false
		end
	end

	if v4 then
		return p.addListener(RoactNavigation.Events.WillFocus, IXPNavigationUtils.createExposureHandler(p2, p3))
	end

	return v
end

function IXPNavigationUtils.setMocksForTesting(p)
	v3 = p or v3
end

function IXPNavigationUtils.restoreDefaultsAfterTesting()
	v3 = IXPService
end

return IXPNavigationUtils
