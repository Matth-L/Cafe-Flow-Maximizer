(**
@file graph.ml
@brief implémentation d'un graph ordonnée 
*)

(* Exception pour les ensembles vides *)
exception EmptySet

(* Exception pour les dictionnaires vides *)
exception EmptyMap

(*
   Exemple 1 : 
   (A)      2        (B)
   |--------------->|
   |               /|
   |              / | 2
   |             /  |
   |            /   v
   |3        4 /   (C)
   |          /
   v         /
   (D)      /
   ^       /
   |      /
   |     /
   |1   /
   |   /
   |  /
   | v
   (E)

   {
    A : {B: 2}
    B : {C: 2};{E: 4}
    C : {}
    D : {}
    E : {D: 1}
    
    Les nodes sont de la forme int NodeMap.t car des élèves ne sont pas divisible 
   }
*)

module type S = sig
  module NodeMap : Map.S

  (* pour l'ensemble de la liste des chemins*)
  module SetOfPath : Set.S

  type graph
  type node

  (** Le graph vide *)
  val empty : graph

  (**********************  LIST TO GRAPH FUNCTION *****************************)

  (**
  @requires une node list
  @ensures un graph ou il y a des edges entre plusieurs noeuds.
  @raises rien 
  *)
  val list_to_graph : (node*node) list -> graph

  (**********************  BOOLEAN FUNCTION ***********************************)

  (**
  @requires Rien 
  @ensures True si graph vide, False sinon 
  @raises Rien 
  *)
  val is_empty : graph -> bool

  (**********************  SUCCS FUNCTION ***********************************)

  (**
  @requires le noeud node appartient au graph 
  @ensures un ensemble correspondant au successeur du noeud 
  passé en paramètre
  @raises le noeud dont on cherche le successeur n'appartient pas au graph 
  *)
  val succs : node -> graph -> 'a NodeMap.t

  (**********************  FOLD FUNCTION ***********************************)

  (*
     Map.fold
     val fold : (key -> 'a -> 'acc -> 'acc) -> 'a t -> 'acc -> 'acc
  *)

  (**
  @requires Rien
  @ensures un fold sur le graph
  @raises Rien
  *)
  val fold_node : (node -> 'a -> 'a) -> graph -> 'a -> 'a

  (**
  @requires Rien
  @ensures un fold sur les successeurs du noeud
  @raises Rien
  *)
  val fold_succs : (node -> 'a -> 'a) -> graph -> 'a -> 'a

  (**********************  MEM FUNCTION ***********************************)

  (**
  @requires Rien 
  @ensures un booléen indiquant si le noeud est dans le graph
  @raises Rien
  *)
  val mem_node : node -> graph -> bool

  (**
  @requires que n1 appartiennent au graph 
  @ensures un booléen indiquant si n1 ---------> n2
  @raises rien 
  *)
  val mem_edge : node -> node -> graph -> bool

  (**
  @requires un noeud 
  @ensures un booléen indiquant si node est un successeurs d'un élement dans le graph
  @raises rien 
  *)
  val mem_exist_as_successor : node -> graph -> bool

  (**********************  ADDING FUNCTION ***********************************)

  (**
  @requires un noeud au graph, ce noeud n'est relié à rien 
  @ensures l'ajout d'un noeud au graph si le noeud existe, il n'est pas rajouté
  @raises Rien
  *)
  val add_lonely_node : node -> graph

  (**
  @brief Fonction qui prend 2 noeud existant et qui lie le noeud A 
  au noeud B avec la pondération n
  @requires les 2 noeuds existent 
  @ensures la création d'une arête entre les 2 noeuds
  @raises rien
  *)
  val add_edge : node -> int -> node -> graph -> graph

  (**
  @brief Même fonction que pour add_edge mais pour les graphe non pondéré (toutes les pondérations sont à 1 )
  @requires les 2 noeuds existent 
  @ensures la création d'une arête entre les 2 noeuds
  @raises EmptyMap 
  *)
  val add_default_edge : node -> graph

  (**
  @brief Fonction qui prend un noeud et un entier, la fonction ajoute un successeur à ce noeud, de pondération n, elle crée donc un node et connecte les 2 
  @requires que le noeud existe dans le graph 
  @ensures, l'ajoute d'un noeud de pondération n , successeur du noeud
  donnée en paramètre 
  @raises EmptyMap si le noeud en paramètre n'existe pas 
  @example add_node (B) 2 (C) (G) (donne le graph ascii plus haut)
  B ----------- 2 ---------> C 
  *)
  val add_node : node -> int -> node -> graph -> graph

  (**
  @brief Même fonction que add_node mais dans un cas non pondéré
  @requires que le noeud existe dans le graph 
  @ensures, l'ajout d'un noeud de pondération n , successeur du noeud
  donnée en paramètre 
  @raises EmptyMap si le noeud en paramètre n'existe pas
  *)
  val add_default_node : node -> node -> graph -> graph

  (**********************  REMOVE FUNCTION ********************************)

  (**
  @requires les 2 nodeuds 
  @ensures que l'arête 1 ------> 2 soit supprimer 
  @raises EmptyMap si les 2 noeuds n'existe pas
  @warning si A ---> A , on supprime l'arête mais pas le noeud
  *)
  val remove_edge : node -> node -> graph -> graph

  (**
  @requires les 2 nodeuds 
  @ensures que l'arête 1 -----> 2 ET 2 --------> 1
  @raises EmptyMap si les 2 noeuds n'existe pas
  *)
  val remove_edges : node -> node -> graph -> graph

  (**
  @requires le noeud à récupérer ainsi que le graph 
  @ensures que le noeud soit bien retirer du graph ainsi que les noeuds qui pointent vers lui
  @raises Riencherche  
  @brief, il faut utiliser un fold , il faut fold le remove edge sur tous
  les noeuds du graph 
  *)
  val remove_node : node -> graph -> graph

  (**********************  COUNTING FUNCTION ********************************)

  (**
  @requires un noeud existant dans graph
  @ensures le nombre d'arc
  @raises le noeud n'est pas dans le graph

  a ----> b 
  c ----> b 

  number_of_incoming_edge 'b' graph ===> 2 

  *)
  val number_of_incoming_edge : node -> graph -> int

  (**
  @requires un noeud existant dans graph
  @ensures le nombre d'arc
  @raises le noeud n'est pas dans le graph

  a ----> b 
  a-----> c
  a-----> a
  c ----> b 

  number_of_outgoing_edge 'a' graph ===> 3

  *)
  val number_of_outgoing_edge : node -> graph -> int

  (*NON TESTER*)

  (**
  @requires un graph
  @ensures un ensemble de chemin correspondant à tous les chemins possible dans le graphe au rang suivant 
  @raises Rien
  *)
  val add_paths_to_set : SetOfPath.t -> graph -> SetOfPath.t

  (**
  @requires un graph
  @ensures un ensemble de chemin correspondant à tous les chemins possible dans le graphe
  @raises Rien
  *)
  val add_paths_to_set_while_possible : SetOfPath.t -> graph -> SetOfPath.t

  (**
  @requires un noeud de départ, un noeud d'arrivé et un graph
  @ensures un ensemble de chemin correspondant à tous les chemins possible dans le graphe
  @raises Rien
  *)
  val bfs : node -> node -> graph -> SetOfPath.t
end

(************************************************************************)
(************************************************************************)
(************************************************************************)
(************************************************************************)
(**********************  IMPLEMENTATION  ********************************)
(************************************************************************)
(************************************************************************)
(************************************************************************)
(************************************************************************)

module Make (X : Map.OrderedType) = struct
  module NodeMap = Map.Make (X)

  type node = X.t
  type graph = int NodeMap.t NodeMap.t

  let empty = NodeMap.empty
  let is_empty g = NodeMap.is_empty g

  (***********  let ***********  SUCCS FUNCTION ***********************************)

  let succs (n : node) (g : graph) =
    (*si le noeud appartient au graph,
      on retourne la clé , sinon on retourne rien*)
    try NodeMap.find n g
    with Not_found -> failwith "succs : le noeud n'apppartient pas au graph"

  (**********************  FOLD FUNCTION ***********************************)

  (*
     le fold n'est fait que sur les clé
  *)
  let fold_node (f : node -> 'a -> 'a) (g : graph) (acc : 'a) =
    NodeMap.fold (fun currNode _ acc -> f currNode acc) g acc

  (*
     Lors du fold, pour chaque clé, on va faire un fold sur les successeurs
     a --> b 
     b --> c
     c --> a 
     a --> c
     { a : {
            b: 1 ; 
            c: 1
            }
       b : {c: 1}
       c : {a: 1}
     }
     l'un des élement qui recevra la fonction f sera b et c du noeud a par ex
  *)
  let fold_succs (f : node -> int -> 'a -> 'a) (g : graph) (acc : 'a) =
    NodeMap.fold
      (fun noeud successeur acc1 ->
        NodeMap.fold
          (fun noeudSuccs ponderation acc2 -> f noeudSuccs ponderation acc2)
          successeur acc1)
      g acc

  (**
  @requires un noeud qui existe au graph
  @ensures, un fold fais sur tous les successeurs d'1 seul noeud
  @raises Rien 
  TODO TEST    
  *)
  let fold_succs_of_1node (n : node) (f : node -> int -> 'a -> 'a) (g : graph)
      (acc : 'a) =
    NodeMap.fold
      (fun noeud successeur acc1 ->
        if noeud = n then
          NodeMap.fold
            (fun noeudSuccs ponderation acc2 -> f noeudSuccs ponderation acc2)
            successeur acc1
        else
          acc1)
      g acc

  (********************** MEM FUNCTION ***********************************)

  let mem_node (n : node) (g : graph) = NodeMap.mem n g

  let mem_edge (n1 : node) (n2 : node) (g : graph) =
    if (mem_node n1 g) then 
      (* si le départ appartient au graph *)
      let succs_of_n1 = succs n1 g in
      NodeMap.mem n2 succs_of_n1
    else 
    false 

  let mem_exist_as_successor (n : node) (g : graph) =
    NodeMap.fold (fun noeud valeur acc -> acc || NodeMap.mem n valeur) g false

  (**********************  ADDING FUNCTION ***********************************)

  let add_lonely_node (n : node) (g : graph) =
    (* si un noeud existe déjà, il n'est pas ajouté au graph *)
    if mem_node n g then
      g
      (*sinon on l'ajoute*)
    else
      NodeMap.add n NodeMap.empty g

  (* fais : n1 ----- (pond) ----> n2 ; si n1 et n2 existe dans le graph *)
  let add_edge (n1 : node) (pond : int) (n2 : node) (g : graph) =
    (*si les 2 noeuds existent dans le graph*)
    if mem_node n1 g && mem_node n2 g then
      (*on récupère les successeurs de n1 *)
      let successor_of_n1 = succs n1 g in
      (*on ajoute n2 à la liste des successeurs de n1*)
      let updated_succs = NodeMap.add n2 pond successor_of_n1 in
      (* on met à jour la clé *)
      NodeMap.add n1 updated_succs g
    else
      failwith "add_edge : les 2 noeuds n'existent pas"

  let add_default_edge (n1 : node) (n2 : node) (g : graph) = add_edge n1 1 n2 g

  let add_node (base_node : node) (ponderation : int) (node_to_add : node)
      (g : graph) =
    (*si le noeud de base existe*)
    let graphWithBase = add_lonely_node base_node g in 
      (*on vérifie qu'on ne crée pas de boucle *)
      if not (base_node = node_to_add) then
        (*on crée le nouveau noeud*)
        let newGraph = add_lonely_node node_to_add graphWithBase in
        (* on lie les 2 noeud *)
        add_edge base_node ponderation node_to_add newGraph
      else
        graphWithBase

  let add_default_node (n1 : node) (n2 : node) (g : graph) = add_node n1 1 n2 g

  (**********************  REMOVE FUNCTION ***********************************)

  let remove_edge (n1 : node) (n2 : node) (g : graph) =
    if mem_node n1 g && mem_node n2 g then
      (*on supprime l'arête n1 -----> n2 *)
      let successor_of_n1 = succs n1 g in
      let updated_successor_of_n1 = NodeMap.remove n2 successor_of_n1 in
      NodeMap.add n1 updated_successor_of_n1 g
    else
      failwith "remove_edge : les 2 noeuds n'existent pas"

  let remove_edges (n1 : node) (n2 : node) (g : graph) =
    let graph_unlink_n1_to_n2 = remove_edge n1 n2 g in
    let graph_unlink_n2_to_n1 = remove_edge n2 n1 graph_unlink_n1_to_n2 in
    graph_unlink_n2_to_n1

  let remove_node (n : node) (g : graph) =
    let graph_without_successor_to_n =
      (* pour le dictionnaire de successeurs, on applique remove,
         afin d'enlever la clé n ,
         et on ajoute cette nouvelle map à la clé , ce qui
         met donc à jour ses successeurs*)
      NodeMap.fold
        (fun noeud valeur acc ->
          NodeMap.add noeud (NodeMap.remove n valeur) acc)
        g NodeMap.empty
    in
    NodeMap.remove n graph_without_successor_to_n

  (********************  COUNTING FUNCTION *********************************)

  (* nombre d'arc qui pointe vers le noeud*)
  let number_of_incoming_edge (n : node) (g : graph) =
    fold_succs
      (fun node ponderation acc ->
        if node = n then
          acc + 1
        else
          acc)
      g 0

  (* nombre d'arc qui quitte le noeud, c'est donc le nombre de successeurs*)
  let number_of_outgoing_edge (n : node) (g : graph) =
    let map_of_succs = succs n g in
    NodeMap.cardinal map_of_succs

  (*TODO PAS TESTER A PARTIR DE LA *)

  (********************  LIST TO GRAPH FUNCTION ****************************)
  (* crée les noeuds ainsi que le lien entre start et finish

  goal : 
  [(a1,b1);(a1,b2)]
  a1 ------> b1
  |
  |--------> b2

  *)

  let list_to_graph (l:(node*int*node) list ) (g:graph)= 
    List.fold_right 
    (fun (start,pond,finish) acc -> 
      add_node start pond finish acc 
    )
    l
    g

  (***********************************************************)
  (********************  BFS *********************************)
  (***********************************************************)

  (**
    BUT
              |-----> f
              |
      a ----> b ----> c
      |               ^
      |-----> d       |
      |               |
      |-----> e ----> g

      1)

      [

      [(b,1)]
      [(d,1)]
      [(e,1)]

      ]
      2)
      focus sur [(b,1)]
      [b,1] =>

      [

      [(c,1);(b,1)]
      [(f,1);(b,1)]

      ]

      puis on remplace (b,1) par le nouveau chemin
      [

      [(c,1);(b,1)]
      [(f,1);(b,1)]
      [(d,1)]
      [(e,1)]

      ]
      **)

  (********************  Ensemble chemin *********************************)

  (*
     pour stocker les chemins, on va utiliser des ensembles,
     cela permet de ne pas se faire avoir par l'ordre et de fold
     sans prendre en compte du sens dans lequel on lit
  *)
  module SetOfPath = Set.Make (struct
    type t = (node * int) list

    let compare = compare
  end)

  (* fonction qui ajoute tous les chemins dans un ensemble de chemin *)
  let add_paths_to_set ensInit (g : graph) =
    (* on fold dans l'ensemble des chemins*)
    SetOfPath.fold
      (fun listOfPath acc ->
        (* on parcours chaque liste correspondant à un chemin*)
        (* le premier élement est la tête*)
        let n, pond = List.hd listOfPath in
        (*on récupère ses successeurs*)
        let succs_of_n = succs n g in
        (*on fold sur tous les successeurs pour les ajouter à l'ensemble des chemins*)
        NodeMap.fold
          (* on ajoute le nouveau chemin à l'ensemble des chemin*)
            (fun nodeSuccessor ponderationSuccesor acc ->
            (* on vérifie si le noeud est déja la , ça permet de ne pas tuer la pile en cas de cycle, pour ça il suffit de regarde si la tête c'est le même ça prend moins de temps qu'un mem *)
            let newPath =
              if List.hd listOfPath = (nodeSuccessor, ponderationSuccesor) then
                listOfPath
              else
                (nodeSuccessor, ponderationSuccesor) :: listOfPath
            in
            SetOfPath.add newPath acc)
          succs_of_n acc)
      ensInit ensInit

  (* fonction qui tant que les élément dans le SetOfPath ont des successerus, appel add_paths_to_set *)
  (* cela permet de remplir l'ensemble de tous les chemins possibles*)
  let rec add_paths_to_set_while_possible ensInit (g : graph) =
    (* on ajoute les chemins tant que c'est possible*)
    let newSetOfPath = add_paths_to_set ensInit g in
    (* si le nouveau set est différent du set de base, on rappel la fonction*)
    if not (SetOfPath.equal ensInit newSetOfPath) then
      add_paths_to_set_while_possible newSetOfPath g
    else
      newSetOfPath

  (* maintenant, il suffit de prendre un noeud de départ et d'appliquer la fonction pour avoir l'ensemmble avec tous les chemins allant de start vers goal *)
  let all_path (start : node) (goal : node) (g : graph) =
    (* on transforme le noeud en ensemble*)
    let startingSet = SetOfPath.singleton [ (start, 0) ] in

    (* on applique la fonction, on a donc tous les chemins possible du graph*)
    let allSet = add_paths_to_set_while_possible startingSet g in

    (* il suffit de remove ceux qui ne commence pas par goal ,
       le plus récent est la tête de la liste il suffit de regarder
       la tête *)
    SetOfPath.filter
      (fun listOfPath ->
        let n, pond = List.hd listOfPath in
        n = goal)
      allSet

  (* fonction qui trouve le plus petit chemin à partir d'un ensemble*)
  let shortestOfSet (set : SetOfPath.t) =
    (*fold sur l'ensemble*)
    SetOfPath.fold
      (fun listOfPath acc ->
        (* on regarde s'il y a plus court*)
        if List.length listOfPath < acc then
          List.length listOfPath
        else
          acc)
      set
      (* on commence en prenant la taille du premier set*)
      (List.length (SetOfPath.choose set))

  (* fonction qui prend tous les chemins dans un ensemble, trouve le plus cours, et filtre afin de garder tout ceux égal au plus court*)
  let allShortestPaths (start : node) (goal : node) (g : graph) =
    let allPath = all_path start goal g in
    let shortest = shortestOfSet allPath in
    SetOfPath.filter
      (fun listOfPath -> List.length listOfPath = shortest)
      allPath

  (***********************************************************)
  (***********************************************************)
  (******************** phase 2 ******************************)
  (***********************************************************)
  (***********************************************************)

  (* V0 :  naive *)

  (* but : la fonction allPath nous donne un ensemble de chemin ou la pondération est marqué
     pour chaque chemin, on va donc prendre cette ensemble, transformé chaque liste d'ensemble en couple
     càd que si l'ensemble était
     couteux car fold sur chaque élement
     {
      [chemin A]
      [chemin B]
      [chemin C]
      [chemin D]
     }
     =>
     {
      (sum_ponderation_A , [chemin A])
      (sum_ponderation_B , [chemin B])
      (sum_ponderation_C , [chemin C])
      (sum_ponderation_D , [chemin D])
     }
  *)
  module SetOfPhase2 = Set.Make (struct
    type t = int * (node * int) list

    let compare = compare
  end)

  (**
  @requires une liste de chemin sous la forme [(a,1) ; (b,2)] ... 
  @ensures  de calculer le nombre total de la pondération d'un trajet 
  @raises rien
  *)
  let total_pond l = List.fold_right (fun (n, pond) acc -> acc + pond) l 0

  (**
  prend un ensemble de chemin et le transforme en ensemble ou chaque élément est un couple de la forme
  (sommePonderationChemin,[chemin])
  @requires un ensemble de chemin
  @ensures un ensemble de chemin avec la somme des pondérations facilement accessible
  @raises rien 
  *)
  let ponderation_of_set ens =
    SetOfPath.fold
      (fun listOfPath acc ->
        SetOfPhase2.add (total_pond listOfPath, listOfPath) acc)
      ens SetOfPhase2.empty

  (*prend le plus chemin avec la plus grosse pondération *)
  let sizeLongestPath ens = 
    SetOfPhase2.fold 
    (
      fun (pond,l) acc -> 
        if pond > acc then pond else acc 
    )
    ens 
    0

  (* filtre qui donnne tous les chemins qui ont la taille supérieur *)
  let longestPath ens = 
    let sizeOfLongest = sizeLongestPath ens in 
    SetOfPhase2.filter 
    ( fun (n,l) -> n = sizeOfLongest )
    ens 

  (* V1 : Dinic  *)



end
