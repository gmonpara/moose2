[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 50
  xmax = 1.0
  xmin = 0.0
  ymax = 0.5
  ymin = 0.0
[]

[MeshModifiers]
  [./noncrack]
    type = BoundingBoxNodeSet
    new_boundary = noncrack
    bottom_left = '0.5 0 0'
    top_right = '1 0 0'
  [../]
  [./right_bottom]
    type = AddExtraNodeset
    new_boundary = 'right_bottom'
    coord = '1.0 0.0'
[../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Modules]
  [./PhaseField]
    [./Nonconserved]
      [./c]
        free_energy = E_el
        kappa = kappa_op
        mobility = L
      [../]
    [../]
  [../]
  [./TensorMechanics]
    [./Master]
      [./mech]
        add_variables = true
        strain = SMALL
        additional_generate_output = stress_yy
        decomposition_method = EigenSolution
      [../]
    [../]
  [../]
[]

[Kernels]
  [./solid_x]
    type = PhaseFieldFractureMechanicsOffDiag
    variable = disp_x
    component = 0
    c = c
  [../]
  [./solid_y]
    type = PhaseFieldFractureMechanicsOffDiag
    variable = disp_y
    component = 1
    c = c
  [../]
[]

[Materials]
  [./pfbulkmat]
    type = GenericConstantMaterial
    prop_names = 'gc_prop l visco'
    prop_values = '1e-3 0.03 1e-4'
  [../]
  [./define_mobility]
    type = ParsedMaterial
    material_property_names = 'gc_prop visco'
    f_name = L
    function = '1.0/(gc_prop * visco)'
  [../]
  [./define_kappa]
    type = ParsedMaterial
    material_property_names = 'gc_prop l'
    f_name = kappa_op
    function = 'gc_prop * l'
  [../]
  [./elastic]
    type = ComputeLinearElasticPFFractureStress
    c = c
    F_name = E_el
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    C_ijkl = '120.0 80.0'
    fill_method = symmetric_isotropic
  [../]
[]

[BCs]
  [./ydisp]
    type = FunctionPresetBC
    variable = disp_y
    boundary = top
    function = 't'
  [../]
  [./yfix]
    type = PresetBC
    variable = disp_y
    boundary = noncrack
    value = 0
  [../]
  [./xfix]
    type = PresetBC
    variable = disp_x
    boundary = right_bottom
    value = 0
  [../]
[]


[Preconditioning]
  active = 'smp'
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient

  solve_type = PJFNK
  #petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  #petsc_options_value = 'asm      31                  preonly       lu           1'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu     superlu_dist'

  line_search = default

  nl_rel_tol = 1e-9
  l_tol = 1e-4
  l_max_its = 15
  nl_max_its = 15

  dt = 1.0e-4
  num_steps = 1000
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
