$ T i t l e   =   " F r o n t e n d   P o r t   I O   R a t e "  
 $ A u t h o r   =   " J e f f r e y   S t r i k "  
 $ P l u g i n V e r s i o n   =   2 . 0 
 #   S t a r t   o f   S e t t i n g s    
 #   E n d   o f   S e t t i n g s 
 # s e t t i n g s   f o r   p l u g i n s  
 $ L i n e T y p e   =   " S t a c k e d A r e a "  
 $ A x i s Y T i t l e   =   " I O P s "  
 $ A x i s X T i t l e   =   " T i m e "  
 $ C h a r t T i t l e   =   " T o t a l   F r o n t E n d   P o r t   I O P s "  
 $ X P r o p e r t y N a m e   =   " T i m e "  
 # s e t t i n g s   f o r   p l u g i n s  
 f u n c t i o n   g e t - H D S S t a t s P o r t I O R a t e   {  
 [ C m d l e t B i n d i n g ( ) ]  
 P a r a m (  
         [ P a r a m e t e r ( M a n d a t o r y = $ T r u e ) ] [ s t r i n g [ ] ] $ C o n t r o l l e r  
 )        
         $ c o n t e n t   =   G e t - C o n t e n t   - p a t h   $ C s v P a t h " \ C T L " $ C o n t r o l l e r " _ P o r t _ I O R a t e . c s v "   |   S e l e c t - O b j e c t   - S k i p   5   |   C o n v e r t F r o m - C s v   - D e l i m i t e r   " , "  
         $ c o n t e n t      
 }  
  
  
 $ F E P o r t C h a r t   =   N e w - P S G r a p h C h a r t   - C h a r t T i t l e   $ C h a r t T i t l e   - A x i s X T i t l e   $ A x i s X T i t l e   - A x i s Y T i t l e   $ A x i s X T i t l e   - A x i s X I n t e r v a l   $ A x i s X I n t e r v a l  
          
 $ c t l 0 v a l u e s   =   g e t - H D S S t a t s P o r t I O R a t e   - C o n t r o l l e r   0  
 $ c t l 1 v a l u e s   =   g e t - H D S S t a t s P o r t I O R a t e   - C o n t r o l l e r   1  
            
 $ p o r t s   =   $ c t l 0 v a l u e s   | g m | W h e r e - O b j e c t   { $ _ . N a m e   - m a t c h   ' ^ [ A B C D E F G H ] '   - a n d   $ _ . M e m b e r T y p e   - e q   ' N o t e P r o p e r t y ' }   |   S e l e c t - O b j e c t   - E x p a n d P r o p e r t y   N a m e    
 N e w - I t e m   - I t e m T y p e   D i r e c t o r y   - F o r c e   - P a t h   " $ G r a p h O u t p u t P a t h \ F E P o r t I O R a t e s "  
  
 f o r e a c h   ( $ p o r t   i n   $ p o r t s ) {  
          
         $ c t l 0 v a l u e s   |   A d d - P S G r a p h S e r i e   - N a m e   " 0 $ p o r t "   - C h a r t N a m e   " F E P o r t C h a r t "   - Y P r o p e r t y N a m e   $ p o r t   - X P r o p e r t y N a m e   $ X P r o p e r t y N a m e   - T y p e   $ L i n e T y p e  
  
 }  
  
 f o r e a c h   ( $ p o r t   i n   $ p o r t s ) {  
      
     $ c t l 1 v a l u e s   |   A d d - P S G r a p h S e r i e   - N a m e   " 1 $ p o r t "   - C h a r t N a m e   " F E P o r t C h a r t "   - Y P r o p e r t y N a m e   $ p o r t   - X P r o p e r t y N a m e   $ X P r o p e r t y N a m e   - T y p e   $ L i n e T y p e  
  
 }  
  
 f o r e a c h   ( $ p o r t   i n   $ p o r t s ) {  
      
     $ F E P o r t S i n g l e C 0 C h a r t   =   N e w - P S G r a p h C h a r t   - C h a r t T i t l e   " $ C h a r t T i t l e   -   P o r t   0 $ p o r t "   - A x i s X T i t l e   $ A x i s X T i t l e   - A x i s Y T i t l e   $ A x i s X T i t l e   - A x i s X I n t e r v a l   $ A x i s X I n t e r v a l  
     $ c t l 0 v a l u e s   |   A d d - P S G r a p h S e r i e   - N a m e   " 0 $ p o r t "   - C h a r t N a m e   " F E P o r t S i n g l e C 0 C h a r t "   - Y P r o p e r t y N a m e   $ p o r t   - X P r o p e r t y N a m e   $ X P r o p e r t y N a m e   - T y p e   $ L i n e T y p e  
     $ F E P o r t S i n g l e C 0 C h a r t . S a v e C h a r t ( " $ G r a p h O u t p u t P a t h \ F E P o r t I O R a t e s \ F E P o r t I O R a t e s _ P o r t 0 $ p o r t . p n g " )  
 }  
  
 f o r e a c h   ( $ p o r t   i n   $ p o r t s ) {  
  
     $ F E P o r t S i n g l e C 1 C h a r t   =   N e w - P S G r a p h C h a r t   - C h a r t T i t l e   " $ C h a r t T i t l e   -   P o r t   1 $ p o r t "   - A x i s X T i t l e   $ A x i s X T i t l e   - A x i s Y T i t l e   $ A x i s X T i t l e   - A x i s X I n t e r v a l   $ A x i s X I n t e r v a l  
     $ c t l 1 v a l u e s   |   A d d - P S G r a p h S e r i e   - N a m e   " 0 $ p o r t "   - C h a r t N a m e   " F E P o r t S i n g l e C 1 C h a r t "   - Y P r o p e r t y N a m e   $ p o r t   - X P r o p e r t y N a m e   $ X P r o p e r t y N a m e   - T y p e   $ L i n e T y p e  
     $ F E P o r t S i n g l e C 1 C h a r t . S a v e C h a r t ( " $ G r a p h O u t p u t P a t h \ F E P o r t I O R a t e s \ F E P o r t I O R a t e s _ P o r t 1 $ p o r t . p n g " )  
  
 }  
  
  
 $ F E P o r t C h a r t . S a v e C h a r t ( " $ G r a p h O u t p u t P a t h \ F E P o r t I O R a t e s \ F E P o r t I O R a t e s . p n g " )  
  
 
