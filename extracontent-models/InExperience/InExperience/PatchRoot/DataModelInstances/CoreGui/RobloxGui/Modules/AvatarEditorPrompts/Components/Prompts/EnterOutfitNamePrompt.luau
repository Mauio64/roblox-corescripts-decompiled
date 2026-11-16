local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local ButtonType = UIBlox.App.Button.Enum.ButtonType

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent.Parent
local parent2 = parent.Parent

local PromptWithTextField = require(parent.Prompts.PromptWithTextField)

local SignalCreateOutfitPermissionDenied = require(parent2.Thunks.SignalCreateOutfitPermissionDenied)
local PerformCreateOutfit = require(parent2.Thunks.PerformCreateOutfit)

local extended = Roact.PureComponent:extend("EnterOutfitNamePrompt")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	signalCreateOutfitPermissionDenied = t.callback,
	performCreateOutfit = t.callback
})

function extended:init()
	self:setState({ outfitName = "", alertPosition = UDim2.fromScale(0.5, 0.5) })

	self.textBoxRef = Roact.createRef()

	function self.confirmCreateOutfit()
		self.props.performCreateOutfit(self.state.outfitName)
	end

	function self.textUpdated(outfitName)
		self:setState({ outfitName = outfitName })
	end
end

function extended.render(props)
	return Roact.createElement(PromptWithTextField, {
		fieldText = props.state.outfitName,
		onFieldTextUpdated = props.textUpdated,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptTitle"),
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = props.props.signalCreateOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptNo")
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = props.state.outfitName == "",
						onActivated = props.confirmCreateOutfit,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptYes")
					},
					isDefaultChild = false
				}
			}
		}
	})
end

local function mapStateToProps(p)
	return { screenSize = p.screenSize }
end

local function mapDispatchToProps(callback)
	return {
		signalCreateOutfitPermissionDenied = function()
			return callback(SignalCreateOutfitPermissionDenied)
		end,
		performCreateOutfit = function(p)
			return callback(PerformCreateOutfit(p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
