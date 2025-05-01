module [page!]

import hasnep.Html exposing [b, p, br, meta, pre, code, head, span, title, html, div, main, form, button, h1, h2, script, link, body, header, text, a]
import hasnep.Attribute exposing [attribute, method, action, style, id, charset, class, src, rel, href, name, content]
import ws.Http exposing [Request]

page! : Request => Html.Node
page! = |_req|
    html [(attribute "data-webtui-theme") "dark"] [
        head [] [
            meta [charset "utf-8"],
            meta [name "viewport", content "width=device-width, initial-scale=2"],
            title [] [text "htmx-roc"],
            script [src "https://unpkg.com/htmx.org@2.0.4"] [],
            script [src "/main.js"] [],
            link [rel "stylesheet", href "/main.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/npm/@webtui/css/dist/full.css"],
            link [rel "stylesheet", href "https://cdn.jsdelivr.net/gh/mshaugh/nerdfont-webfonts@latest/build/jetbrainsmono-nfm.css"],
        ],
        body [class "content"] [
            main [class "login-form", style "padding-top: 10ch; text-align:center"] [
                pre [] [
                    code [] [
                        text (logo {}),
                    ],
                ],
                b [] [text "Todo Application"],
                p [] [
                    text "In swift code it flows",
                    br [],
                    text "Tasks arise and fade like waves",
                    br [],
                    text "Scaling without end",
                ],
                div [style "padding-top: 3ch"] [
                    a
                        [
                            href "/dashboard",
                            (attribute "box-") "square",
                            style "color: var(--foreground0)",
                            (attribute "hx-boost") "true",
                            (attribute "hx-trigger") "keyup[key=='a'] from:body",
                        ]
                        [
                            text "Authenticate [a]",
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
                            text "Register [r]",
                        ],
                ],
            ],
        ],
    ]

logo : {} -> Str
logo = |{}|
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
