local ViewportInputTypeTestFixtures = {}

function ViewportInputTypeTestFixtures.mouseMovement(vector3: Vector3?)
	return {
		UserInputType = Enum.UserInputType.MouseMovement,
		Position = vector3 or Vector3.new(0, 0, 0)
	}
end

function ViewportInputTypeTestFixtures.mouseButton1(vector3: Vector3?)
	return {
		UserInputType = Enum.UserInputType.MouseButton1,
		Position = vector3 or Vector3.new(0, 0, 0)
	}
end

function ViewportInputTypeTestFixtures.mouseButton2(vector3: Vector3?)
	return {
		UserInputType = Enum.UserInputType.MouseButton2,
		Position = vector3 or Vector3.new(0, 0, 0)
	}
end

function ViewportInputTypeTestFixtures.mouseWheel(p: number)
	return { UserInputType = Enum.UserInputType.MouseWheel, Position = Vector3.new(0, 0, p) }
end

function ViewportInputTypeTestFixtures.touch(vector3: Vector3?)
	return {
		UserInputType = Enum.UserInputType.Touch,
		Position = vector3 or Vector3.new(0, 0, 0)
	}
end

function ViewportInputTypeTestFixtures.keyboard()
	return { UserInputType = Enum.UserInputType.Keyboard }
end

return ViewportInputTypeTestFixtures
