local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Thunks.CloseOpenPrompt)
local v9 = Roact.PureComponent:extend("ContextActionsBinder")

v9.validateProps = t.strictInterface({
	promptOpen = t.boolean,
	closeOpenPrompt = t.callback
})

function v9.init(p1) -- line: 27
	p1.actionsBound = false
end
function v9.bindActions(p2) -- line: 31
	-- upvalues: ContextActionService (copy), GuiService (copy)
	if p2.actionsBound then
		return
	end

	p2.actionsBound = true
	ContextActionService:BindCoreAction("CloseAvatarEditorPrompt", function(_, p4, _) -- line: 38
		-- upvalues: GuiService (copy), p2 (copy)
		if GuiService.MenuIsOpen then
			return Enum.ContextActionResult.Pass
		end

		if p4 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		p2.props.closeOpenPrompt()

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Escape)
end
function v9.unbindActions(p6) -- line: 51
	-- upvalues: ContextActionService (copy)
	if not p6.actionsBound then
		return
	end

	p6.actionsBound = false
	ContextActionService:UnbindCoreAction("CloseAvatarEditorPrompt")
end
function v9.didMount(p7) -- line: 61
	if p7.props.promptOpen then
		p7:bindActions()
	end
end
function v9.render(_) -- line: 67
	return nil
end
function v9.didUpdate(p9, p10, _) -- line: 71
	if p9.props.promptOpen ~= p10.promptOpen then
		if p9.props.promptOpen then
			p9:bindActions()

			return
		end

		p9:unbindActions()
	end
end
function v9.willUnmount(p12) -- line: 81
	if p12.actionsBound then
		p12:unbindActions()
	end
end

local function mapStateToProps(p13) -- line: 87
	return {
		promptOpen = p13.promptInfo.promptType ~= nil
	}
end
local function mapDispatchToProps(p14) -- line: 93
	-- upvalues: CloseOpenPrompt (copy)
	return {
		closeOpenPrompt = function() -- line: 95
			-- upvalues: p14 (copy), CloseOpenPrompt (copy)
			return p14(CloseOpenPrompt)
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v9)
