local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local ChatLineReporting = require(CorePackages.Workspace.Packages.ChatLineReporting)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ChatLineReportSelectionModal = ChatLineReporting.ChatLineReportSelectionModal
local ChatLineSelectionMode = ChatLineReporting.Enums.ChatLineSelectionMode
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useStyle = UIBlox.Core.Style.useStyle
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot

require(AbuseReportMenu.Components.Types)

local useOrderedMessages = require(AbuseReportMenu.Hooks.useOrderedMessages)

local function ChatModalSelectorDialog(t1: {[any]: any}) -- line: 28
	-- upvalues: useStyle (copy), useOrderedMessages (copy), React (copy), ChatLineReportSelectionModal (copy), ChatLineSelectionMode (copy)
	local Theme = useStyle().Theme
	local v16 = useOrderedMessages()
	local v17 = React.useCallback(function(t2: {[any]: any}?) -- line: 33
		-- upvalues: t1 (copy), v16 (copy)
		t1.onSelect(t2, v16)
		t1.onClose()
	end, { v16 })

	if not t1.isShown then
		return nil
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Overlay = React.createElement("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency,
			Position = UDim2.fromScale(0.5, 0.5),
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			ZIndex = 10,
			[React.Event.Activated] = function() -- line: 56
				-- upvalues: t1 (copy)
				t1.onClose()
			end
		}),
		ChatLineReportSelectionModalFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 11,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		}, React.createElement(ChatLineReportSelectionModal, {
			isCentered = true,
			onContinue = v17,
			onBack = t1.onClose,
			mode = ChatLineSelectionMode.Direct,
			messages = v16,
			analyticsDispatch = function() -- line: 74
			end
		}))
	})
end

function DialogWrapper(t3: {[any]: any}) -- line: 80
	-- upvalues: React (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), ChatModalSelectorDialog (copy)
	return React.createElement(FocusRoot, {
		isIsolated = true,
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
	}, {
		DialogContainer = React.createElement(ChatModalSelectorDialog, t3)
	})
end

return DialogWrapper
