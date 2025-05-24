module [entry]

import platform.Http
import template.Html exposing [a, br, code, div, main, p, pre, text]
import template.Attribute exposing [attribute, class, href, style]

import Templates.Base

entry : Http.Request -> Html.Node
entry = |_req|
    main [class "content"] [
        div [class "entry"] [
            pre [class "logo"] [code [] [text logo]],
            p [class "title"] [text "THE TODO APP"],
            p [class "haiku"] [
                text "In swift code it flows",
                br [],
                text "Tasks arise and fade like waves",
                br [],
                text "Scaling without end",
            ],
            div [class "buttons"] [
                a
                    [
                        href "/dashboard",
                        (attribute "box-") "square",
                        style "color: var(--foreground0)",
                        (attribute "hx-boost") "true",
                        (attribute "hx-trigger") "keyup[key=='a'] from:body",
                    ]
                    [
                        text "authenticate [a]",
                    ],
                a
                    [
                        href "/register",
                        (attribute "box-") "square",
                        style "color: var(--foreground0)",
                        (attribute "hx-boost") "true",
                        (attribute "hx-trigger") "keyup[key=='r'] from:body",
                    ]
                    [
                        text "register [r]",
                    ],
            ],
        ],
    ]
    |> Templates.Base.base

logo =
    """
    .............                                               
    ...========..............                                 
      ..=====================..                               
        ..====================...                             
          ..====================..                            
            ..====================..                          
             ...===================..                         
               ...===================..                       
                 ...==================...                     
                   ...==================..                    
                     ...==================..       .....      
                       ...=================........====...    
                         ...=============================..   
                           ...=======================.......  
                             .=======================.        
                            ..======================..        
                            .======================..         
                            .===================...           
                           ..=================...             
                           .===============...                
                           .=============...                  
                          .-==========...                     
                          .=========...                       
                         ..======...                          
                         .======..                            
                         .======.                             
                        ..======..                            
                        .========.                            
                        .======...                            
                       ..====...                              
                       .==...                                 
                      .....                                   
                      ...

    """
