return function(n1: number?, n2: number?, n3: number?) -- line: 26
	local ModuleScript = Instance.new("ModuleScript")

	ModuleScript.Source = ("\tlocal Root = script:FindFirstAncestor(\"JestConfigs\")\n\tlocal Packages = Root.Parent\n\t\n\tlocal JestGlobals = require(Packages.JestGlobals)\n\tlocal beforeAll = JestGlobals.beforeAll\n\tlocal afterAll = JestGlobals.afterAll\n\tlocal expect = JestGlobals.expect\n\t\n\tlocal UnitTestHelpersPromiseRejectionHandler = require(Packages.UnitTestHelpersPromiseRejectionHandler)\n\tlocal createPromiseRejectionHandler = UnitTestHelpersPromiseRejectionHandler.createPromiseRejectionHandler\n\n\tlocal RejectionHandler = createPromiseRejectionHandler()\n\t\n\tbeforeAll(function()\n\t\tRejectionHandler.inject()\n\tend)\n\t\n\tafterAll(function()\n\t\texpect(function()\n\t\t\tRejectionHandler.reportRejections(%s, %s, %s)\n\t\tend).never.toThrow()\n\tend)\n"):format(tostring(n1), tostring(n2), (tostring(n3)))
	ModuleScript.Parent = script.Parent

	return ModuleScript
end
