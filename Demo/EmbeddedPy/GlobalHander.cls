Class Demo.EmbeddedPy.GlobalHander Extends %RegisteredObject
{

ClassMethod SetGlobal() [ Language = python ]
{
import iris
#create a global reference
g = iris.gref('^mygbl')
g[1],g[2]='Mon','Tue'
g["95752455",1]=iris.execute('return $LFS("Ashok,55720,9639639639,test@gmail.com",",")')
g["85752400",1]=iris.execute('return $LB("Test","9517539635","t@gmail.com")')
g["test","c1"]=iris.execute('return ##Class(MyLearn.EmbeddedPython).executeAndGetResult()') # method wil return some listbuild values
# declare values by using set function
g.set([3],'Wed')
g.set([3,1,1],'Test multilevel')
}

/// Get Global values inside embedded python
ClassMethod GetGlobal() [ Language = python ]
{
    import iris
    #gets a global reference
    g = iris.gref('^mybgl')
    # get values
    print(g[3,1,1])
    print(g.get([2,1]))
    print(g["95752455",1])
}

/// Traversal
/// $Order
ClassMethod DollarOrder() [ Language = python ]
{
    import iris
    g = iris.gref('^MyLearn.EmbeddedPythonD') # I use my persistent class global
    key = ''
    while True:
        key = g.order([key])
        if key == None:
            break
        print(f'{key} {g.get([key])}')
}

/// $Order multilevel Traversal
ClassMethod DollarOrderMultiLevel() [ Language = python ]
{
 import iris
 g = iris.gref('^mygbl')
 key1= ''
 while True:
 	key1 = g.order([key1])
 	if key1== None:
 		break
 	key2 = ''
 	while True:
 		key2 = g.order([key1,key2])
 		if key2 == None:
 			break
 		value = g.get([key1,key2])
 		print(key1,key2,value)
}

/// $Query
ClassMethod DollarQuery() [ Language = python ]
{
 	import iris
 	g = iris.gref('^mygbl')
 	key = g.query()#this will return tuples of all the subscripts
 	for x in key:
 		print(x) # output (['3', '1', '1'], 'Test multilevel')
}

/// $Data
ClassMethod DollarData() [ Language = python ]
{
    import iris
    g = iris.gref('^mygbl')
    key1= ''
    print(g.data([1]))
}

}
