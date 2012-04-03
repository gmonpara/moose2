[GlobalParams]
  disp_x = disp_x
  disp_y = disp_y
  disp_z = disp_z
[]

[Mesh]#Comment
  file = hoops.e
  displacements = 'disp_x disp_y disp_z'
[] # Mesh

[Functions]
  [./pressure]
    type = PiecewiseLinear
    x = '0. 1.'
    y = '0. 1.'
    scale_factor = 1e3
  [../]
[] # Functions

[Variables]

  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]

[] # Variables

[AuxVariables]

  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./hoop1]
    order = CONSTANT
    family = MONOMIAL
    block = 1
  [../]
  [./hoop2]
    order = CONSTANT
    family = MONOMIAL
    block = 2
  [../]
  [./hoop3]
    order = CONSTANT
    family = MONOMIAL
    block = 3
  [../]

[] # AuxVariables

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[AuxKernels]

  [./stress_xx]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
    execute_on = timestep
  [../]
  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
    execute_on = timestep
  [../]
  [./stress_zz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zz
    index = 2
    execute_on = timestep
  [../]
  [./stress_xy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xy
    index = 3
    execute_on = timestep
  [../]
  [./stress_yz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yz
    index = 4
    execute_on = timestep
  [../]
  [./stress_zx]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zx
    index = 5
    execute_on = timestep
  [../]
  [./hoop1]
    type = MaterialTensorAux
    tensor = stress
    quantity = hoop
    variable = hoop1
    block = 1
    point1 = '20 20 -4'
    point2 = '20 20 47'
    execute_on = timestep
  [../]
  [./hoop2]
    type = MaterialTensorAux
    tensor = stress
    quantity = hoop
    variable = hoop2
    block = 2
    point1 = '-25 12 20'
    point2 = '-25 10 20'
    execute_on = timestep
  [../]
  [./hoop3]
    type = MaterialTensorAux
    tensor = stress
    quantity = hoop
    variable = hoop3
    block = 3
    point1 = '0 -20 20'
    point2 = '16 -20 20'
    execute_on = timestep
  [../]

[] # AuxKernels

[BCs]

  [./fix_x]
    type = DirichletBC
    variable = disp_x
    boundary = '300 11'
    value = 0
  [../]
  [./fix_y]
    type = DirichletBC
    variable = disp_y
    boundary = '200 12'
    value = 0
  [../]
  [./fix_z]
    type = DirichletBC
    variable = disp_z
    boundary = '100 13'
    value = 0
  [../]

  [./Pressure]
    [./internal_pressure]
      boundary = 1
      function = pressure
    [../]
  [../]

[] # BCs

[Materials]

  [./stiffStuff1]
    type = Elastic
    block = '1 2 3'

    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z

    youngs_modulus = 1e6
    poissons_ratio = 0.35
  [../]

[] # Materials

[Executioner]

  type = Transient
  petsc_options = '-snes_mf_operator -ksp_monitor -ksp_gmres_modifiedgramschmidt'
  petsc_options_iname = '-snes_type -snes_ls -ksp_gmres_restart -pc_type  -pc_hypre_type'
  petsc_options_value = 'ls         basic   201                 hypre     boomeramg     '

  nl_abs_tol = 1e-10

  l_max_its = 20

  start_time = 0.0
  dt = 1.0
  num_steps = 1
  end_time = 1.0
[] # Executioner

[Output]
  interval = 1
  output_initial = true
  exodus = true
  perf_log = true
[] # Output
