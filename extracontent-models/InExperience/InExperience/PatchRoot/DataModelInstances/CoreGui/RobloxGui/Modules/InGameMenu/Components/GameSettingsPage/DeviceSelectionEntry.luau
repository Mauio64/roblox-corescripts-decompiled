local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local SoundService = game:GetService("SoundService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local DropDownSelection = require(ParentParent.Components.DropDownSelection)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local v12 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local v13 = Roact.PureComponent:extend("DeviceSelectionEntry")
local Flags = ParentParent.Flags
local GetFFlagTruncateDeviceSelection = require(Flags.GetFFlagTruncateDeviceSelection)
local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)

v13.DeviceType = {
	Input = "Input",
	Output = "Output"
}
v13.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	deviceType = t.string,
	isMenuOpen = t.boolean,
	canOpen = t.optional(t.boolean),
	canCaptureFocus = t.optional(t.boolean)
})
v13.defaultProps = {
	canOpen = true
}

function v13.init(p1) -- line: 41
	-- upvalues: default (copy), SoundService (copy), GetFFlagVoiceChatUILogging (copy), v12 (copy)
	p1:setState({
		selectedIndex = 0,
		ready = false,
		deviceNames = {},
		deviceGuids = {}
	})
	default:asyncInit():andThen(function() -- line: 50
		-- upvalues: p1 (copy), default (copy), SoundService (copy)
		p1:setState({
			ready = true
		})
		default:SetupParticipantListeners()

		if SoundService.DeviceListChanged then
			SoundService.DeviceListChanged:Connect(function() -- line: 56
				-- upvalues: p1 (copy)
				if p1.props.isMenuOpen then
					p1:pollDevices(p1.props.deviceType)
				end
			end)
		end
	end):catch(function() -- line: 63
		-- upvalues: GetFFlagVoiceChatUILogging (copy), v12 (copy)
		if GetFFlagVoiceChatUILogging() then
			v12:warning("Failed to init VoiceChatServiceManager")
		end
	end)
end
function v13.render(p2) -- line: 70
	-- upvalues: Roact (copy), ThemedTextLabel (copy), v13 (copy), DropDownSelection (copy), GetFFlagTruncateDeviceSelection (copy), default (copy)
	if not p2.state.ready or (p2.state.deviceNames == nil or #p2.state.deviceNames == 0) then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, 120),
		LayoutOrder = p2.props.LayoutOrder
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		InputLabel = Roact.createElement(ThemedTextLabel, {
			fontKey = "Body",
			themeKey = "TextDefault",
			Size = UDim2.new(1, 0, 0, 56),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Text = p2.props.deviceType ~= v13.DeviceType.Input and "Output Device" or "Input Device",
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		Dropdown = Roact.createElement(DropDownSelection, {
			placeHolderText = "",
			enabled = true,
			localize = false,
			Size = UDim2.new(1, 0, 0, 44),
			Position = UDim2.new(0, 0, 0, 56),
			truncate = GetFFlagTruncateDeviceSelection(),
			selections = p2.state.deviceNames,
			selectedIndex = p2.state.selectedIndex,
			selectionParentName = p2.props.deviceType .. "DeviceSelectionEntryDropdown",
			canOpen = p2.props.canOpen,
			canCaptureFocus = p2.props.canCaptureFocus,
			selectionChanged = function(p3) -- line: 107
				-- upvalues: default (copy), p2 (copy)
				default:SwitchDevice(p2.props.deviceType, p2.state.deviceNames[p3], p2.state.deviceGuids[p3])
				p2:setState({
					selectedIndex = p3
				})
			end
		})
	})
end
function v13.pollDevices(p4, p5) -- line: 122
	-- upvalues: default (copy), GetFFlagVoiceChatUILogging (copy), v12 (copy)
	spawn(function() -- line: 123
		-- upvalues: default (copy), p5 (copy), p4 (copy), GetFFlagVoiceChatUILogging (copy), v12 (copy)
		local v24, v25, v26, v27 = default:GetDevices(p5)

		if v24 then
			p4:setState({
				deviceNames = v25,
				deviceGuids = v26,
				selectedIndex = v27
			})

			return
		end

		if GetFFlagVoiceChatUILogging() then
			v12:warning("Errors in get {} Device info", p5)
		end

		p4:setState({
			selectedIndex = 0,
			deviceNames = {},
			deviceGuids = {}
		})
	end)
end
function v13.willUpdate(p6, p7) -- line: 144
	if not p6.props.isMenuOpen and p7.isMenuOpen then
		p6:pollDevices(p7.deviceType)
	end
end

return v13
