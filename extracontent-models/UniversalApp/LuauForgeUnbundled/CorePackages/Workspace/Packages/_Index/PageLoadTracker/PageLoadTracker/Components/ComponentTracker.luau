local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/React")

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/RoactUtils").Hooks.RoactRodux.useSelector
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/SharedFlags")

local createPageTracker = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/createPageTracker")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageTrackerContext")
local isElementInScreenBounds = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/isElementInScreenBounds")
local PageLoadConfig = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/PageLoadConfig")
local VisualDebugManager = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/PageLoadTracker/VisualDebugManager")

local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/PageLoadTracker/ExperienceService").ExperienceService

local function usePageTracker(isActive, componentName)
	local v5 = React.useMemo(function()
		return createPageTracker()
	end, {})

	if isActive then
		v5:start(componentName)
	else
		v5:stop()
	end

	React.useEffect(function()
		v5:sendMilestone("first_react_frame_rendered")
		local connection

		if SharedFlags.FFlagLuaAppPageLoadTrackerJoinExperienceFix then
			connection = experienceService:RegisterForExperienceJoin(function()
				v5:stop()
			end)
		else
			connection = nil
		end

		return function()
			v5:stop()

			if SharedFlags.FFlagLuaAppPageLoadTrackerJoinExperienceFix and connection then
				connection:Disconnect()
			end
		end
	end, {})

	return v5
end

local function ComponentTracker(props)
	local v5 = usePageTracker(props.isActive, props.componentName)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer and ref.current == nil then
		ref.current = VisualDebugManager.new()
	end

	local v6 = useSelector(function(p2)
		return p2.ScreenSize or PageLoadConfig.SCREEN_BOUNDS.DEFAULT_SCREEN_SIZE
	end)

	local v7 = useSelector(function(p2)
		return p2.TopBar and p2.TopBar.topBarHeight or PageLoadConfig.SCREEN_BOUNDS.DEFAULT_TOP_BAR_HEIGHT
	end)

	local function addTrackingToChild(guiObject)
		if not guiObject:IsA("GuiObject") then
			return
		end

		if isElementInScreenBounds(guiObject, v6, v7) then
			v5:onComponentAdded(guiObject)

			if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
				ref.current:highlightComponent(guiObject)
			end
		end
	end

	local function setupChildTracking(folder)
		for i, guiObject in folder:GetDescendants() do
			if SharedFlags.FFlagLuaAppImproveComponentTrackingTiming then
				task.defer(function()
					local guiObject2 = guiObject

					if not guiObject2:IsA("GuiObject") then
						return
					end

					if isElementInScreenBounds(guiObject2, v6, v7) then
						v5:onComponentAdded(guiObject2)

						if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
							ref.current:highlightComponent(guiObject2)
						end
					end
				end)
			elseif guiObject:IsA("GuiObject") and isElementInScreenBounds(guiObject, v6, v7) then
				v5:onComponentAdded(guiObject)

				if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
					ref.current:highlightComponent(guiObject)
				end
			end
		end

		return (folder.DescendantAdded:Connect(function(guiObject)
			if SharedFlags.FFlagLuaAppImproveComponentTrackingTiming then
				task.defer(function()
					local guiObject2 = guiObject

					if not guiObject2:IsA("GuiObject") then
						return
					end

					if isElementInScreenBounds(guiObject2, v6, v7) then
						v5:onComponentAdded(guiObject2)

						if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
							ref.current:highlightComponent(guiObject2)
						end
					end
				end)
				return
			end

			if not guiObject:IsA("GuiObject") then
				return
			end

			if isElementInScreenBounds(guiObject, v6, v7) then
				v5:onComponentAdded(guiObject)

				if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
					ref.current:highlightComponent(guiObject)
				end
			end
		end))
	end

	if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
		React.useEffect(function()
			return function()
				ref.current:destroy()
			end
		end, {})
	end

	React.useLayoutEffect(function()
		if not props.isActive then
			return
		end

		local connection = setupChildTracking(ref2.current)

		if not SharedFlags.FFlagPageLoadAllowImprovedDisconnectTiming then
			return function()
				connection:Disconnect()
			end
		end

		v5.onCompleteSignal:connect(function()
			connection:Disconnect()
		end)
	end, { props.isActive })

	return React.createElement(
		"Frame",
		{ ref = ref2, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 },
		{
			PageTrackerContext = React.createElement(module4.Provider, { value = v5 }, props.children)
		}
	)
end

return ComponentTracker
