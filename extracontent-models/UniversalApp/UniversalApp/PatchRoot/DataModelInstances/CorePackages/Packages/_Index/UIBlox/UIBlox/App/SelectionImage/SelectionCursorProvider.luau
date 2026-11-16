local parent = script.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)
local RoactGamepad = require(parent.RoactGamepad)
local Cryo = require(parent.Cryo)

local CursorKind = require(script.Parent.CursorKind)
local SelectionImageContext = require(script.Parent.SelectionImageContext)
local OnRootedListener = require(script.Parent.OnRootedListener)
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local extended = Roact.PureComponent:extend("SelectionCursorProvider")

function extended:init()
	self.ref = Roact.createRef()
	self.refs = RoactGamepad.createRefCache()
	self.state = { mountedCursors = {}, currentSelection = nil, currentCoreSelection = nil }

	function self.getSelectionCursor(p)
		assert(
			CursorKind.isEnumValue(p),
			("Invalid arg #1: expected a CursorKind enum variant, got %s"):format((tostring(p)))
		)

		warn("UIBlox's SelectionCursor is deprecated and should not be used anymore.")

		if self.state.mountedCursors[p] == nil then
			self:setState(function(p2)
				return {
					mountedCursors = Cryo.Dictionary.join(p2.mountedCursors, { [p] = true })
				}
			end)
		end

		return self.refs[p]
	end

	function self.initSelectionChangedListener(instance)
		if instance == nil then
			return
		end

		if self.coreSelectionListener ~= nil then
			self.coreSelectionListener:Disconnect()
			self.coreSelectionListener = nil
		end

		if self.selectionListener ~= nil then
			self.selectionListener:Disconnect()
			self.selectionListener = nil
		end

		if instance:IsDescendantOf(CoreGui) then
			self.coreSelectionListener = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
				if
					self.state.currentCoreSelection == nil
					or GuiService.SelectedCoreObject == nil
					or self.state.currentCoreSelection.SelectionImageObject ~= GuiService.SelectedCoreObject.SelectionImageObject
				then
					self:setState({ currentCoreSelection = GuiService.SelectedCoreObject })
				end
			end)
		else
			self.selectionListener = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
				if
					self.state.currentSelection == nil
					or GuiService.SelectedObject == nil
					or self.state.currentSelection.SelectionImageObject ~= GuiService.SelectedObject.SelectionImageObject
				then
					self:setState({ currentSelection = GuiService.SelectedObject })
				end
			end)
		end
	end
end

function extended.didMount(p)
	p.initSelectionChangedListener(p.ref:getValue())
end

function extended:willUnmount()
	if self.coreSelectionListener ~= nil then
		self.coreSelectionListener:Disconnect()
		self.coreSelectionListener = nil
	end

	if self.selectionListener ~= nil then
		self.selectionListener:Disconnect()
		self.selectionListener = nil
	end
end

function extended.render(props)
	local children = {}

	for k, _ in pairs(props.state.mountedCursors) do
		local rawValue = k.rawValue()
		local v = tostring(rawValue)

		local isVisible = props.refs[k] ~= nil
			and (props.state.currentSelection ~= nil and props.refs[k].current == props.state.currentSelection.SelectionImageObject or props.state.currentCoreSelection ~= nil and props.refs[k].current == props.state.currentCoreSelection.SelectionImageObject)

		children[v] = Roact.createElement(rawValue, {
			isVisible = isVisible,
			cursorRef = props.refs[k]
		})
	end

	return Roact.createElement(SelectionImageContext.Provider, { value = props.getSelectionCursor }, {
		CursorContainer = Roact.createElement("Frame", {
			Size = UDim2.new(0, 0, 0, 0),
			Visible = false
		}, children),
		OnRootedListener = Roact.createElement(OnRootedListener, {
			onRooted = props.initSelectionChangedListener
		}),
		Children = Roact.createFragment(props.props[Roact.Children])
	})
end

return extended
