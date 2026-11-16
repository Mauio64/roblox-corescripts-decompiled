local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local FocusHandlerContext = require(script.Parent.FocusHandlerContext)

local extended = Roact.PureComponent:extend("FocusHandlerContextProvider")

function extended:init()
	self.state = { candidateHandlerId = nil, currentHandlerId = nil }

	self.previousSelections = {}
end

function extended:requestFocusForHandlerId(p)
	self:setState(function(p2)
		if p2.currentHandlerId == nil then
			return { currentHandlerId = p }
		end

		if p == p2.currentHandlerId then
			return nil
		end

		return { candidateHandlerId = p }
	end)
end

function extended:blurCurrentFocusHandler(p, p2)
	self:setState(function(p3)
		if p3.currentHandlerId ~= p then
			return nil
		end

		local v

		if not p2 then
			v = GuiService.SelectedCoreObject
		end

		self.previousSelections[p] = v

		if p3.candidateHandlerId == nil then
			return { currentHandlerId = Roact.None }
		end

		return { currentHandlerId = p3.candidateHandlerId, candidateHandlerId = Roact.None }
	end)
end

function extended:forgetLastSelectionForHandlerId(p)
	self.previousSelections[p] = nil
end

function extended:render()
	return Roact.createElement(FocusHandlerContext.Provider, {
		value = {
			currentHandlerId = self.state.currentHandlerId,
			candidateHandlerId = self.state.candidateHandlerId,
			previousSelections = self.previousSelections,
			requestFocusForHandlerId = function(p)
				self:requestFocusForHandlerId(p)
			end,
			forgetLastSelectionForHandlerId = function(p)
				self:forgetLastSelectionForHandlerId(p)
			end,
			blurCurrentFocusHandler = function(p, p2)
				self:blurCurrentFocusHandler(p, p2)
			end
		}
	}, self.props[Roact.Children])
end

return extended
