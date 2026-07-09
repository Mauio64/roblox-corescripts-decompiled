local Parent = script:FindFirstAncestor("SceneManagement").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local v6 = React.createContext(nil)

local function SurfaceGuiWithAdornee(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), v6 (copy), ReactRoblox (copy), Workspace (copy), CoreGui (copy)
	local v9 = React.useRef(nil)
	local v10 = React.useRef(nil)
	local v11 = React.useRef(nil)
	local v12 = React.useContext(v6)
	local v13 = v12 == nil

	return React.createElement(v6.Provider, {
		value = v11
	}, {
		AdorneePortal = ReactRoblox.createPortal({
			Adornee = React.createElement("Part", {
				Transparency = 1,
				CanCollide = false,
				CanTouch = false,
				Name = `{ t1.name }_Part`,
				ref = v9,
				Size = t1.adorneeSize,
				CFrame = if not v13 then nil else t1.adorneeCFrame,
				Anchored = v13
			}, {
				ParentAttachment = if not v13 then React.createElement(React.Fragment, nil, {
					SelfAttachment = React.createElement("Attachment", {
						Name = `{ t1.name }_SelfAttachment`,
						CFrame = t1.adorneeCFrame,
						ref = v10
					}),
					ParentConstraint = React.createElement("RigidConstraint", {
						Enabled = true,
						Name = `{ t1.name }_ParentConstraint`,
						Attachment0 = v12,
						Attachment1 = v10
					})
				}) else nil,
				ChildrenAttachment = React.createElement("Attachment", {
					Name = `{ t1.name }_ChildrenAttachment`,
					CFrame = CFrame.identity,
					ref = v11
				})
			})
		}, t1.adorneeParent or Workspace),
		SurfaceGuiPortal = ReactRoblox.createPortal({
			SurfaceGui = React.createElement("SurfaceGui", {
				Active = true,
				AlwaysOnTop = true,
				LightInfluence = 0,
				Name = `{ t1.name }_SurfaceGui`,
				Adornee = v9,
				Enabled = t1.isVisible,
				CanvasSize = t1.canvasSize,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, t1.children)
		}, t1.surfaceGuiParent or CoreGui)
	})
end

return SurfaceGuiWithAdornee
