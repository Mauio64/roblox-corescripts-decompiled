local ParentParent = script.Parent.Parent

return (require(ParentParent.PolicyProvider).GetPolicyImplementations.MemStorageService("app-policy"))
