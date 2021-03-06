(: Copyright (c) Microsoft Corporation.
   Licensed under the MIT license. :)

(: Export formdatafieldstr extension information in CSV format :)

let $options := map { 'lax': false(), 'header': true() ,'format': 'attributes' }

(: Cache all classes for looking up package :)
let $forms := map:merge(
  for $c in /Form
  return map:entry(lower-case($c/@Name), lower-case($c/@Package))
)

(: Cache the extension classes :)
let $extensions := <Extensions>
{
    for $c in /Class
    for $attr in $c/AttributeList/Attribute[lower-case(@Name)='extensionof']
    where lower-case($attr/AttributeExpression/IntrinsicAttributeLiteral/@FunctionName) = 'formdatafieldstr'
    let $extensionof := lower-case($attr/AttributeExpression/IntrinsicAttributeLiteral/@Arg1)
    let $datasource := lower-case($attr/AttributeExpression/IntrinsicAttributeLiteral/@Arg2)
    let $datafield := lower-case($attr/AttributeExpression/IntrinsicAttributeLiteral/@Arg3)
    
    return <Extension ExtendedType='{$extensionof}' DataSource='{$datasource}' DataField='{$datafield}' ExtensionClass='{lower-case($c/@Name)}' ExtensionClassPackage='{lower-case($c/@Package)}'>
    </Extension>
}</Extensions>

let $r := <ExtensionsOnMethods>
{
  for $e in $extensions/Extension
  return <Record>
      <Extension name=':START_ID'>{ lower-case("/" || $e/@ExtensionClassPackage || "/classes/" || $e/@ExtensionClass)}</Extension>
      <Extended name=':END_ID'>{ lower-case("/" || map:get($forms, $e/@ExtendedType) || "/forms/" || $e/@ExtendedType || "/datasource/" || $e/@DataSource || "/datafield/" || $e/@DataField )}</Extended>
      <Type name=':TYPE'>EXTENSIONOF</Type>
  </Record>
  
}
</ExtensionsOnMethods>


return csv:serialize($r, $options)




