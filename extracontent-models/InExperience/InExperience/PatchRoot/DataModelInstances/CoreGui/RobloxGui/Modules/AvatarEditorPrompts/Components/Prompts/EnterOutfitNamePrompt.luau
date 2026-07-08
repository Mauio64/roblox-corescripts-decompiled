local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ButtonType = require(CorePackages.Packages.UIBlox).App.Button.Enum.ButtonType

CoreGui:WaitForChild("RobloxGui")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local PromptWithTextField = require(ParentParent.Prompts.PromptWithTextField)
local SignalCreateOutfitPermissionDenied = require(ParentParentParent.Thunks.SignalCreateOutfitPermissionDenied)
local PerformCreateOutfit = require(ParentParentParent.Thunks.PerformCreateOutfit)
local v13 = Roact.PureComponent:extend("EnterOutfitNamePrompt")

v13.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	signalCreateOutfitPermissionDenied = t.callback,
	performCreateOutfit = t.callback
})

function v13.init(p1) -- line: 33
	-- upvalues: Roact (copy)
	p1:setState({
		outfitName = "",
		alertPosition = UDim2.fromScale(0.5, 0.5)
	})
	p1.textBoxRef = Roact.createRef()

	function p1.confirmCreateOutfit() -- line: 41
		-- upvalues: p1 (copy)
		p1.props.performCreateOutfit(p1.state.outfitName)
	end
	function p1.textUpdated(p2) -- line: 45
		-- upvalues: p1 (copy)
		p1:setState({
			outfitName = p2
		})
	end
end
function v13.render(p3) -- line: 52
	-- upvalues: Roact (copy), PromptWithTextField (copy), RobloxTranslator (copy), ButtonType (copy)
	return Roact.createElement(PromptWithTextField, {
		fieldText = p3.state.outfitName,
		onFieldTextUpdated = p3.textUpdated,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptTitle"),
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p3.props.signalCreateOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptNo")
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = p3.state.outfitName == "",
						onActivated = p3.confirmCreateOutfit,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptYes")
					}
				}
			}
		}
	})
end

local function mapStateToProps(p4) -- line: 82
	return {
		screenSize = p4.screenSize
	}
end
local function mapDispatchToProps(p5) -- line: 88
	-- upvalues: SignalCreateOutfitPermissionDenied (copy), PerformCreateOutfit (copy)
	return {
		signalCreateOutfitPermissionDenied = function() -- line: 90
			-- upvalues: p5 (copy), SignalCreateOutfitPermissionDenied (copy)
			return p5(SignalCreateOutfitPermissionDenied)
		end,
		performCreateOutfit = function(p6) -- line: 94
			-- upvalues: p5 (copy), PerformCreateOutfit (copy)
			return p5(PerformCreateOutfit(p6))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v13)
