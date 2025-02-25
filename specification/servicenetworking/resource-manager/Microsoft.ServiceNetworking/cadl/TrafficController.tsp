import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-providerhub";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

@armProviderNamespace
@service({
  title: "TrafficController",
  version: "2023-05-01-preview",
})
@doc("Traffic Controller Provider management API.")
@useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
@useDependency(Azure.Core.Versions.v1_0_Preview_1)
namespace Microsoft.ServiceNetworking;

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;


//----------------------- Frontends -----------------------
@doc("Frontend Subresource of Traffic Controller.")
@parentResource(TrafficController)
model Frontend is TrackedResource<FrontendProperties>{
  @key("frontendName")
  @doc("Frontends")
  @visibility("read")
  @path
  @segment("frontends")
  name : string;
}

@doc("Frontend Properties.")
model FrontendProperties {
  @visibility("read")
  @doc("The Fully Qualified Domain Name of the DNS record associated to a Traffic Controller frontend.")
  fqdn : string;

  @visibility("read")
  @doc("Provisioning State of Traffic Controller Frontend Resource")
  provisioningState?: ProvisioningState;
}

//----------------------- Associations -----------------------
@doc("Association Subresource of Traffic Controller")
@parentResource(TrafficController)
model Association is TrackedResource<AssociationProperties> {
  @key("associationName")
  @visibility("read")
  @doc("Name of Association")
  @path
  @segment("associations")
  name: string;
}

@doc("Association Properties.")
model AssociationProperties { 
  @doc("Association Type")
  associationType: AssociationType;
  @doc("Association Subnet")
  subnet?: AssociationSubnet;
  @visibility("read")
  @doc("Provisioning State of Traffic Controller Association Resource")
  provisioningState?: ProvisioningState;

}

enum AssociationType {
  "subnets",
}

@doc("Association Subnet.")
model AssociationSubnet {
  @doc("Association ID.")
  id: string;
}

//----------------------- Traffic Controller -----------------------
@resource("trafficControllers")
model TrafficController is TrackedResource<TrafficControllerProperties> {
  @key("trafficControllerName")
  @path
  @segment("trafficControllers")
  @doc("traffic controller name for path")
  name: string;
}

@doc("Traffic Controller Properties.")
model TrafficControllerProperties {
  @doc("Configuration Endpoints.")
  @visibility("read")
  configurationEndpoints?: string[];
  @visibility("read")
  @doc("Frontends References List")
  frontends? : ResourceId[];
  @visibility("read")
  @doc("Associations References List")
  associations? : ResourceId[];
  @visibility("read")
  @doc("The status of the last operation.")
  provisioningState?: ProvisioningState;
}

@lroStatus
enum ProvisioningState{
  Provisioning,
  Updating,
  Deleting,
  Accepted,
  Succeeded, 
  Failed, 
  Canceled
}

@doc("Resource ID definition used by parent to reference child resources.")
model ResourceId{
  @doc("Resource ID of child resource.")
  id : string;
}

//----------------------- Paths -----------------------
@armResourceOperations
interface AssociationsInterface extends ResourceInstanceOperations<Association, AssociationProperties>, ResourceListByParent<Association>{
}

@armResourceOperations
interface FrontendsInterface extends ResourceInstanceOperations<Frontend, FrontendProperties>, ResourceListByParent<Frontend>{
}

@armResourceOperations
interface TrafficControllerInterface extends TrackedResourceOperations<TrafficController, TrafficControllerProperties>{
}

interface Operations extends Azure.ResourceManager.Operations {}
