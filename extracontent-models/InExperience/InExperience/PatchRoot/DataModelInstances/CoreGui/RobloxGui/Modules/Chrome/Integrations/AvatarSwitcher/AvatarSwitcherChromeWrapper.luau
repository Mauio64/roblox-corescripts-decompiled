local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local useEventConnection = require(CorePackages.Packages.ReactUtils).useEventConnection
local Foundation = require(CorePackages.Packages.Foundation)
local Service = require(Chrome.Service)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)

require(Chrome.ChromeShared.Service.WindowSizeSignal)

local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local AvatarSwitcherContainer = require(CorePackages.Workspace.Packages.AvatarSwitcher).Components.AvatarSwitcherContainer

local function shouldUseVerticalLayout(uDim2: UDim2) -- line: 27
	return uDim2.X.Offset / uDim2.Y.Offset < 1.2
end
local function AvatarSwitcherChromeWrapper(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), RobloxGui (copy), GuiService (copy), useEventConnection (copy), ViewportUtil (copy), Foundation (copy), AvatarSwitcherContainer (copy), Service (copy), Constants (copy)
	local windowSize = t1.windowSize
	local useState = React.useState
	local v19 = windowSize:get()
	local v20, v21 = useState(v19.X.Offset / v19.Y.Offset < 1.2)
	local v22, v23 = React.useState(false)
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
	local v25 = React.useCallback(function(vector2: Vector2) -- line: 45
		-- upvalues: GuiService (copy), t1 (copy), windowSize (copy), v23 (copy)
		local MaxY = GuiService.TopbarInset.Max.Y
		local v28 = vector2.X < t1.maxWindowWidth or vector2.Y - MaxY < t1.maxWindowHeight

		if v28 then
			windowSize:requestSize(vector2.X, vector2.Y - MaxY)
		else
			windowSize:requestSize(math.min(t1.maxWindowWidth, vector2.X), (math.min(t1.maxWindowHeight, vector2.Y - MaxY)))
		end

		v23(v28)
	end, {
		windowSize,
		t1.maxWindowWidth,
		t1.maxWindowHeight,
		v22
	})

	useEventConnection(GuiService:GetPropertyChangedSignal("TopbarInset"), function() -- line: 60
		-- upvalues: v25 (copy), ViewportUtil (copy)
		v25(ViewportUtil.screenSize:get())
	end)
	React.useEffect(function() -- line: 64
		-- upvalues: ViewportUtil (copy), v25 (copy), windowSize (copy), v21 (copy)
		local v29 = ViewportUtil.screenSize:connect(v25)
		local v30 = windowSize:connect(function(p1) -- line: 66
			-- upvalues: v21 (copy)
			v21(p1.X.Offset / p1.Y.Offset < 1.2)
		end)

		v25(ViewportUtil.screenSize:get())

		return function() -- line: 70
			-- upvalues: v29 (copy), v30 (copy)
			v29:disconnect()
			v30:disconnect()
		end
	end, { v25 })

	return React.createElement(Foundation.View, {
		tag = `size-full { not v22 and "" or "padding-x-large padding-top-medium padding-bottom-xlarge" }`
	}, {
		AvatarSwitcherContainer = React.createElement(AvatarSwitcherContainer, {
			getRespawnBehaviour = SettingsHub.GetRespawnBehaviour,
			respawnBehaviorChangedEvent = SettingsHub.RespawnBehaviourChangedEvent,
			toggleWindow = function() -- line: 82
				-- upvalues: Service (copy), Constants (copy)
				Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
			end,
			verticalLayout = v20
		})
	})
end

return AvatarSwitcherChromeWrapper
