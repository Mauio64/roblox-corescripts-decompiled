local parent = script.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Shared = require(parent.Shared)

local RoactTree = require(script.RoactTree)

return {
	Component = React.Component,
	PureComponent = React.PureComponent,
	createElement = React.createElement,
	createRef = React.createRef,
	forwardRef = React.forwardRef,
	createContext = React.createContext,
	None = React.None,
	mount = RoactTree.mount,
	update = RoactTree.update,
	unmount = RoactTree.unmount,
	createFragment = require(script.createFragment),
	oneChild = require(script.oneChild),
	setGlobalConfig = require(script.setGlobalConfig),
	Portal = require(script.Portal),
	Ref = "ref",
	Children = "children",
	Event = Shared.Event,
	Change = Shared.Change,
	createBinding = React.createBinding,
	joinBindings = React.joinBindings,
	act = ReactRoblox.act
}
