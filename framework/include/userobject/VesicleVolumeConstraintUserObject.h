/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef VESICLEVOLUMECONSTRAINTUSEROBJECT_H
#define VESICLEVOLUMECONSTRAINTUSEROBJECT_H

#include "ShapeElementUserObject.h"

//Forward Declarations
class VesicleVolumeConstraintUserObject;

template<>
InputParameters validParams<VesicleVolumeConstraintUserObject>();

class VesicleVolumeConstraintUserObject :
  public ShapeElementUserObject
{
public:
  VesicleVolumeConstraintUserObject(const InputParameters & parameters);

  virtual ~VesicleVolumeConstraintUserObject() {}

  virtual void initialize();
  virtual void execute();
  virtual void executeJacobian(unsigned int jvar);
  virtual void finalize();
  virtual void threadJoin(const UserObject & y);

  ///@{ custom UserObject interface functions
  const Real & getIntegral() const { return _integral; }
  const std::vector<Real> & getJacobian() const { return _jacobian_storage; }
  ///@}

protected:
  Real _integral;
  std::vector<Real> _jacobian_storage;

  const VariableValue & _u_value;
  unsigned int _u_var;
};

#endif
