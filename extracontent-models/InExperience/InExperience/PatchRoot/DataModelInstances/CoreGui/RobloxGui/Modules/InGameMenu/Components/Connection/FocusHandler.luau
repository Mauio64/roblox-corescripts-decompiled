local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo

local GetFFlagIGMGamepadSelectionHistory = require(script.Parent.Parent.Parent.Flags.GetFFlagIGMGamepadSelectionHistory)
local FocusHandlerContext = require(script.Parent.FocusHandlerUtils.FocusHandlerContext)

local id = 1

local extended = Roact.PureComponent:extend("FocusHandler")

local strictInterface = t.strictInterface
local v = {}

v.isFocused = t.boolean

v.didFocus = t.optional(t.callback)

v.didBlur = t.optional(t.callback)
local shouldForgetPreviousSelection

if GetFFlagIGMGamepadSelectionHistory() then
	shouldForgetPreviousSelection = t.optional(t.boolean) or nil
end

v.shouldForgetPreviousSelection = shouldForgetPreviousSelection
local currentHandlerId

if GetFFlagIGMGamepadSelectionHistory() then
	currentHandlerId = t.optional(t.number) or nil
end

v.currentHandlerId = currentHandlerId
local candidateHandlerId

if GetFFlagIGMGamepadSelectionHistory() then
	candidateHandlerId = t.optional(t.number) or nil
end

v.candidateHandlerId = candidateHandlerId
local previousSelections

if GetFFlagIGMGamepadSelectionHistory() then
	previousSelections = t.table or nil
end

v.previousSelections = previousSelections
local requestFocusForHandlerId

if GetFFlagIGMGamepadSelectionHistory() then
	requestFocusForHandlerId = t.callback or nil
end

v.requestFocusForHandlerId = requestFocusForHandlerId
local forgetLastSelectionForHandlerId

if GetFFlagIGMGamepadSelectionHistory() then
	forgetLastSelectionForHandlerId = t.callback or nil
end

v.forgetLastSelectionForHandlerId = forgetLastSelectionForHandlerId
local blurCurrentFocusHandler

if GetFFlagIGMGamepadSelectionHistory() then
	blurCurrentFocusHandler = t.callback or nil
end

v.blurCurrentFocusHandler = blurCurrentFocusHandler

v[Roact.Children] = t.optional(t.table)
extended.validateProps = strictInterface(v)

if GetFFlagIGMGamepadSelectionHistory() then
	function extended:init()
		self.id = id
		id += 1
	end
end

function extended.render(p)
	return Roact.createFragment(p.props[Roact.Children])
end

if GetFFlagIGMGamepadSelectionHistory() then
	function extended.didMount(p)
		if p.props.isFocused then
			p.props.requestFocusForHandlerId(p.id)
		end
	end
else
	function extended.didMount(p)
		if p.props.isFocused then
			p.props.didFocus()
		end
	end
end

if GetFFlagIGMGamepadSelectionHistory() then
	function extended.didUpdate(p, data)
		local v2 = p.props.shouldForgetPreviousSelection and not data.shouldForgetPreviousSelection

		local previousSelection = p.props.previousSelections[p.id]

		if v2 or previousSelection ~= nil and not previousSelection:IsDescendantOf(game) then
			p.props.forgetLastSelectionForHandlerId(p.id)
			previousSelection = nil
		end

		local v3

		if p.props.candidateHandlerId == p.id then
			v3 = false
		else
			v3 = p.props.candidateHandlerId ~= nil
		end

		local v4

		if data.candidateHandlerId == p.id then
			v4 = false
		else
			v4 = data.candidateHandlerId ~= nil
		end

		local v5

		if p.props.currentHandlerId == p.id then
			v5 = data.currentHandlerId ~= p.id
		else
			v5 = false
		end

		local isFocused = p.props.currentHandlerId == nil
			and data.currentHandlerId ~= nil
			and data.currentHandlerId ~= p.id
			and not v3
			and p.props.isFocused
		local isFocused2 = not data.isFocused and p.props.isFocused

		local v6 = data.isFocused and not p.props.isFocused or v3 and not v4
		local v7

		if data.currentHandlerId == p.id then
			v7 = p.props.currentHandlerId ~= p.id
		else
			v7 = false
		end

		if isFocused2 or isFocused then
			p.props.requestFocusForHandlerId(p.id)
		elseif v5 and p.props.didFocus then
			p.props.didFocus(previousSelection)
		end

		if v6 and p.props.currentHandlerId == p.id then
			p.props.blurCurrentFocusHandler(p.id, p.props.shouldForgetPreviousSelection)
		end

		if v7 and p.props.didBlur then
			p.props.didBlur()
		end
	end
else
	function extended.didUpdate(p, p2)
		if p.props.isFocused and not p2.isFocused and p.props.didFocus then
			p.props.didFocus()
		elseif not p.props.isFocused and p2.isFocused and p.props.didBlur then
			p.props.didBlur()
		end
	end
end

if GetFFlagIGMGamepadSelectionHistory() then
	function extended.willUnmount(p)
		if p.props.isFocused then
			p.props.blurCurrentFocusHandler(p.id, true)

			if p.props.didBlur then
				p.props.didBlur()
			end
		else
			p.props.forgetLastSelectionForHandlerId(p.id)
		end
	end
else
	function extended.willUnmount(p)
		if p.props.isFocused and p.props.didBlur then
			p.props.didBlur()
		end
	end
end

if not GetFFlagIGMGamepadSelectionHistory() then
	return extended
end

local function FocusHandlerWithContext(p)
	return Roact.createElement(FocusHandlerContext.Consumer, {
		render = function(props)
			return Roact.createElement(extended, Cryo.Dictionary.join(p, {
				currentHandlerId = props.currentHandlerId,
				previousSelections = props.previousSelections,
				requestFocusForHandlerId = props.requestFocusForHandlerId,
				forgetLastSelectionForHandlerId = props.forgetLastSelectionForHandlerId,
				blurCurrentFocusHandler = props.blurCurrentFocusHandler,
				candidateHandlerId = props.candidateHandlerId
			}))
		end
	})
end

return FocusHandlerWithContext
