local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent.Parent

local ClosePlayerDropDown = require(parent.Actions.ClosePlayerDropDown)
local SetIsUsingGamepad = require(parent.Actions.SetIsUsingGamepad)

local EventConnection = require(script.Parent.EventConnection)

local extended = Roact.PureComponent:extend("UserInputServiceConnector")

function extended.render(p)
	return Roact.createFragment({
		InputBeganConnection = Roact.createElement(EventConnection, {
			event = UserInputService.InputBegan,
			callback = function(p2, p3)
				if not p.props.playerDropdownVisible or p3 then
					return
				end

				local userInputType = p2.UserInputType

				if userInputType == Enum.UserInputType.Touch or userInputType == Enum.UserInputType.MouseButton1 then
					p.props.closePlayerDropDown()
				end
			end
		}),
		LastInputTypeChangedConnection = Roact.createElement(EventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p2)
				local v = p2.Name:find("Gamepad") ~= nil

				if v == p.props.isUsingGamepad then
					return
				end

				p.props.setIsUsingGamepad(v)
			end
		})
	})
end

local function mapStateToProps(p)
	return {
		playerDropdownVisible = p.playerDropDown.isVisible,
		isUsingGamepad = p.displayOptions.isUsingGamepad
	}
end

local function mapDispatchToProps(callback)
	return {
		closePlayerDropDown = function()
			return callback(ClosePlayerDropDown())
		end,
		setIsUsingGamepad = function(p)
			return callback(SetIsUsingGamepad(p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
