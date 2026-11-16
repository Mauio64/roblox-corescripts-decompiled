local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent.Parent

local CloseOpenPrompt = require(parent.Thunks.CloseOpenPrompt)

local extended = Roact.PureComponent:extend("ContextActionsBinder")

extended.validateProps = t.strictInterface({ promptOpen = t.boolean, closeOpenPrompt = t.callback })

function extended:init()
	self.actionsBound = false
end

function extended:bindActions()
	if self.actionsBound then
		return
	end

	self.actionsBound = true

	ContextActionService:BindCoreAction("CloseAvatarEditorPrompt", function(_, p, _)
		if GuiService.MenuIsOpen or p ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		self.props.closeOpenPrompt()
		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Escape)
end

function extended:unbindActions()
	if not self.actionsBound then
		return
	end

	self.actionsBound = false

	ContextActionService:UnbindCoreAction("CloseAvatarEditorPrompt")
end

function extended:didMount()
	if self.props.promptOpen then
		self:bindActions()
	end
end

function extended.render(_): nil
	return nil
end

function extended:didUpdate(p, _)
	if self.props.promptOpen ~= p.promptOpen then
		if self.props.promptOpen then
			self:bindActions()
		else
			self:unbindActions()
		end
	end
end

function extended:willUnmount()
	if self.actionsBound then
		self:unbindActions()
	end
end

local function mapStateToProps(p)
	return {
		promptOpen = p.promptInfo.promptType ~= nil
	}
end

local function mapDispatchToProps(callback)
	return {
		closeOpenPrompt = function()
			return callback(CloseOpenPrompt)
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
