Class Demo.EmbeddedPy.ObjectHandler Extends %RegisteredObject
{

Property Name As %String;

Property Phone As %Integer;

Parameter MYPARAM As STRING = "DefaultValue";

ClassMethod CreateIRISObjectInstance() [ Language = python ]
{
 #this method calls the %OnNew callback method and get the object
 import iris
 try:
     iris_obj =  iris.cls(__name__)._New()
     if not iris.cls(__name__).IsObj(iris_obj):
      #IsObj is the objectscript wrapper method : which contains $Isobject()
         raise ReferenceError('Object Initlize Error')
 except ReferenceError as e:
     print(e)
     return
 #set the object properties and save the values
 iris_obj.Name = 'Ashok'
 iris_obj.Phone = 9639639635
 #status = iris_obj._Save() # use this if you want to save the object in the database
 #print(status)
 #return status
}

ClassMethod GetProperties()
{
    set pyList = ##class(%SYS.Python).ToList($LB("Name","Phone"))
    do ..pyGetPropertiesAtRunTime(pyList)
}

ClassMethod pyGetPropertiesAtRunTime(properties) [ Language = python ]
{
    import iris
    iris_obj = iris.cls(__name__)._OpenId(1)
    for prop in properties:
        print(getattr(iris_obj,prop))
}

ClassMethod pySetPropertiesAtRunTime(properties As %SYS.Python) [ Language = python ]
{
	import iris
	iris_obj = iris.cls(__name__)._New()
	for prop in properties:
		setattr(iris_obj, prop,properties[prop])

	status = iris_obj._Save()
	return status
}

ClassMethod ClassObjectAccess() [ Language = objectscript ]
{
	Set obj = ..%New()
	Do obj.DefineProperty("test")
    Write obj.PropAccess(),!
}

Method PropAccess() [ Language = python ]
{
return self.Name
}

Method DefineProperty(name) [ Language = python ]
{
self.Name = name
}

/// Get parameter Class prameter values inside embeeded python
ClassMethod GetParam(parameter = "MYPARAM") [ Language = python ]
{
	import iris
	value = iris.cls(__name__)._GetParameter(parameter)
	print(value)
}

/// invocation of class methods directly using class name
ClassMethod InvokeStaticClassMethods(clsName = "MyLearn.EmbeddedPython") [ Language = python ]
{
	import iris
	print(iris.cls(clsName).Test())
	# print(iris.cls(__name__).Test())
}

/// invocation of class methods dynamically using method name at runtime
ClassMethod InvokeClassMethodsRunTime(classMethod As %String = "Test") [ Language = python ]
{
 import iris
 clsMethodRef = getattr(iris.cls(__name__), classMethod) # will return the reference of the method
 print(clsMethodRef())
}

ClassMethod Test()
{
    return "Static method invoked successfully"
}

Method TestMethod(a, b, c)
{
    return a + b + c
}

/// Invoke the instance methods
ClassMethod InvokeInstanceMethodWithActualParameters() [ Language = python ]
{
	import iris
	obj = iris.cls(__name__)._New()
	print(obj.TestMethod(1,2,4))
}

/// Pass by value
ClassMethod passbyvalfromCOStoPY()
{
    Set name = "test", dob= "12/2/2002", city="chennai"
    Do ..pypassbyvalfromCOStoPY(name, dob, city)
}

ClassMethod pypassbyvalfromCOStoPY(name As %String, dob As %String, city As %String) [ Language = python ]
{
   print(name,'  ',dob,'  ',city)
}

/// pass by value from  python to object script
ClassMethod pypassbyvalfromPY2COS() [ Language = python ]
{
	import iris
	name = 'test'
	dob='12/2/2002'
	city='chennai'
	iris.cls(__name__).passbyvalfromPY2COS(name, dob, city)
}

ClassMethod passbyvalfromPY2COS(name As %String, dob As %String, city As %String)
{
    zwrite name,dob,city
}

/// Pass by reference
ClassMethod pypassbyReffromPY2COS() [ Language = python ]
{
	import iris
	name='python'
	dob=iris.ref('01/01/1991')
	city = iris.ref('chennai')
	print('before COS ',name,'  ',dob.value,'  ',city.value)
	#pass by reference of dob, city
	iris.cls('MyLearn.EmbeddedPythonUtils').passbyReffromPY2COS(name, dob, city)
	print('after COS ',name,'  ',dob.value,'  ',city.value)
}

ClassMethod passbyReffromPY2COS(name, ByRef dob, ByRef city)
{
  Set name="object script", dob="12/12/2012", city="miami"
}

/// **kwargs- There is an additional support for passing the python keyword arguments
ClassMethod KWArgs()
{
    set kwargs={ "name": "ashok", "city": "chennai"}
    do ..pyKWArgs(kwargs...)
}

ClassMethod pyKWArgs(name, city, dob = "") [ Language = python ]
{
    print(name, city, dob)
}

}
