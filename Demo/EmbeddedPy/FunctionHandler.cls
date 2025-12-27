Class Demo.EmbeddedPy.FunctionHandler Extends %RegisteredObject
{

/// Create python list in objectscript
ClassMethod CreatePythonList()
{
    set pyList = ##class(%SYS.Python).ToList($LB("Apple","Banana","Grapes","Orange"))
}

/// Create python dictionary and set values via objectscript
ClassMethod SetpyDictProperties()
{
	Set pyDict = ##class(%SYS.Python).Builtins().dict()
	do pyDict.setdefault("Name1", "Ashok kumar")
	do pyDict.setdefault("Phone", "9639639635")
	do pyDict.setdefault("City", "Zanesville")
}

ClassMethod SwitchNamespace() [ Language = python ]
{
    import iris
    print(iris.cls('%SYSTEM.SYS').NameSpace())
    print(iris.system.Process.SetNamespace("USER"))
    try:
        iris.cls('User.EmbeddedPython').pyGetTemplateString()
    except RuntimeError as e:
        print("Wrong NameSpace",e)
}

/// Invoke routines from embedded python
ClassMethod RunRoutines() [ Language = python ]
{
    import iris
    iris.routine('^myirispython')
    iris.routine('add^myirispython',1,2) # same as write $$add^myirispython(1,2)
}

}
