local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent.Parent
local ClosePlayerDropDown = require(ParentParent.Actions.ClosePlayerDropDown)
local SetIsUsingGamepad = require(ParentParent.Actions.SetIsUsingGamepad)
local EventConnection = require(script.Parent.EventConnection)
local v9 = Roact.PureComponent:extend("UserInputServiceConnector")
local v10 = game:DefineFastFlag("PlayerListFilterInputServiceDispatches", false)

function v9.render(p1) -- line: 19
	-- upvalues: Roact (copy), EventConnection (copy), UserInputService (copy), v10 (copy)
	return Roact.createFragment({
		InputBeganConnection = Roact.createElement(EventConnection, {
			event = UserInputService.InputBegan,
			callback = function(p2, p3) -- line: 23
				-- upvalues: v10 (copy), p1 (copy)
				if v10 and not p1.props.playerDropdownVisible then
					return
				end

				if p3 then
					return
				end

				local UserInputType = p2.UserInputType

				if UserInputType == Enum.UserInputType.Touch or UserInputType == Enum.UserInputType.MouseButton1 then
					p1.props.closePlayerDropDown()
				end
			end
		}),
		LastInputTypeChangedConnection = Roact.createElement(EventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p4) -- line: 41
				-- upvalues: v10 (copy), p1 (copy)
				local v21 = p4.Name:find("Gamepad") ~= nil

				if v10 and v21 == p1.props.isUsingGamepad then
					return
				end

				p1.props.setIsUsingGamepad(v21)
			end
		})
	})
end

local function mapStateToProps(p5) -- line: 55
	return {
		playerDropdownVisible = p5.playerDropDown.isVisible,
		isUsingGamepad = p5.displayOptions.isUsingGamepad
	}
end
local function mapDispatchToProps(p6) -- line: 62
	-- upvalues: ClosePlayerDropDown (copy), SetIsUsingGamepad (copy)
	return {
		closePlayerDropDown = function() -- line: 64
			-- upvalues: p6 (copy), ClosePlayerDropDown (copy)
			return p6(ClosePlayerDropDown())
		end,
		setIsUsingGamepad = function(p7) -- line: 68
			-- upvalues: p6 (copy), SetIsUsingGamepad (copy)
			return p6(SetIsUsingGamepad(p7))
		end
	}
end

local v13 = v10 and mapStateToProps or nil

return RoactRodux.connect(v13, mapDispatchToProps)(v9)
