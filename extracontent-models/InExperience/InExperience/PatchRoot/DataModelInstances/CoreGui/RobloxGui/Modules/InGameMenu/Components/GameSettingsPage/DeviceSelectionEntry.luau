local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local SoundService = game:GetService("SoundService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent
local DropDownSelection = require(parent.Components.DropDownSelection)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local extended = Roact.PureComponent:extend("DeviceSelectionEntry")

local flags = parent.Flags
local GetFFlagTruncateDeviceSelection = require(flags.GetFFlagTruncateDeviceSelection)

local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)

extended.DeviceType = { Input = "Input", Output = "Output" }

extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	deviceType = t.string,
	isMenuOpen = t.boolean,
	canOpen = t.optional(t.boolean),
	canCaptureFocus = t.optional(t.boolean)
})

extended.defaultProps = { canOpen = true }

function extended:init()
	self:setState({ deviceNames = {}, deviceGuids = {}, selectedIndex = 0, ready = false })

	default:asyncInit():andThen(function()
		self:setState({ ready = true })

		default:SetupParticipantListeners()

		if SoundService.DeviceListChanged then
			SoundService.DeviceListChanged:Connect(function()
				if self.props.isMenuOpen then
					self:pollDevices(self.props.deviceType)
				end
			end)
		end
	end):catch(function()
		if GetFFlagVoiceChatUILogging() then
			v:warning("Failed to init VoiceChatServiceManager")
		end
	end)
end

function extended.render(object)
	if object.state.ready and object.state.deviceNames ~= nil and #object.state.deviceNames ~= 0 then
		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 120),
				BackgroundTransparency = 1,
				LayoutOrder = object.props.LayoutOrder,
				ZIndex = 2
			},
			{
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
					Text = object.props.deviceType == extended.DeviceType.Input and "Input Device" or "Output Device",
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Dropdown = Roact.createElement(DropDownSelection, {
					Size = UDim2.new(1, 0, 0, 44),
					Position = UDim2.new(0, 0, 0, 56),
					truncate = GetFFlagTruncateDeviceSelection(),
					selections = object.state.deviceNames,
					selectedIndex = object.state.selectedIndex,
					placeHolderText = "",
					enabled = true,
					localize = false,
					selectionParentName = object.props.deviceType .. "DeviceSelectionEntryDropdown",
					canOpen = object.props.canOpen,
					canCaptureFocus = object.props.canCaptureFocus,
					selectionChanged = function(selectedIndex)
						default:SwitchDevice(
							object.props.deviceType,
							object.state.deviceNames[selectedIndex],
							object.state.deviceGuids[selectedIndex]
						)

						object:setState({ selectedIndex = selectedIndex })
					end
				})
			}
		)
	end

	return nil
end

function extended:pollDevices(p)
	spawn(function()
		local devices, deviceNames, deviceGuids, selectedIndex = default:GetDevices(p)

		if devices then
			self:setState({
				deviceNames = deviceNames,
				deviceGuids = deviceGuids,
				selectedIndex = selectedIndex
			})
			return
		end

		if GetFFlagVoiceChatUILogging() then
			v:warning("Errors in get {} Device info", p)
		end

		self:setState({ deviceNames = {}, deviceGuids = {}, selectedIndex = 0 })
	end)
end

function extended:willUpdate(p)
	if not self.props.isMenuOpen and p.isMenuOpen then
		self:pollDevices(p.deviceType)
	end
end

return extended
