import Navbar from "./components/Navbar";
import HomePage from "./components/HomePage";
import "./App.css";

// Import Government
import AdminPublic from "./components/Government/Admin/AdminPublic";
import NAdminPublic from "./components/Government/NonAdmin/NAdminPublic";

import AdminAadhar from "./components/Government/Admin/AdminAadhar";
import NAdminAadhar from "./components/Government/NonAdmin/NAdminAadhar";

import AdminPan from "./components/Government/Admin/AdminPan";
import NAdminPan from "./components/Government/NonAdmin/NAdminPan";

import AdminVoter from "./components/Government/Admin/AdminVoter";
import NAdminVoter from "./components/Government/NonAdmin/NAdminVoter";

import AdminWheeler2 from "./components/Government/Admin/DrivingLicense/AdminWheeler2";
import NAdminWheeler2 from "./components/Government/NonAdmin/DrivingLicense/NAdminWheeler2";

import AdminWheeler4 from "./components/Government/Admin/DrivingLicense/AdminWheeler4";
import NAdminWheeler4 from "./components/Government/NonAdmin/DrivingLicense/NAdminWheeler4";

// Import Education->Engineering
import AdminIIITNR from "./components/Education/Admin/Engineering/AdminIIITNR";
import NAdminIIITNR from "./components/Education/NonAdmin/Engineering/NAdminIIITNR";

// Import Education->Others
import AdminCoursera from "./components/Education/Admin/Others/AdminCoursera";
import NAdminCoursera from "./components/Education/NonAdmin/Others/NAdminCoursera";

// Import Healthcare
import AdminHealthcare from "./components/Healthcare/Admin/AdminHealthcare";
import NAdminHealthcare from "./components/Healthcare/NonAdmin/NAdminHealthcare";

// Import Finance
import Finance from "./components/Finance/Finance";

// Import NFTs
import Nft from "./components/NFTs/Nft";

import { BrowserRouter as Router, Route, Switch } from "react-router-dom";

function App() {
  return (
    <div className="text-white" id="body-screen">
      <Router>
        <Navbar />
        <Switch>
          <Route exact path="/">
            <HomePage />
          </Route>
          {/* Government */}
          <Route exact path="/government/admin-public">
            <AdminPublic />
          </Route>
          <Route exact path="/government/public">
            <NAdminPublic />
          </Route>
          <Route exact path="/government/admin-aadhar">
            <AdminAadhar />
          </Route>
          <Route exact path="/government/aadhar">
            <NAdminAadhar />
          </Route>
          <Route exact path="/government/admin-pan">
            <AdminPan />
          </Route>
          <Route exact path="/government/pan">
            <NAdminPan />
          </Route>
          <Route exact path="/government/admin-voter">
            <AdminVoter />
          </Route>
          <Route exact path="/government/voter">
            <NAdminVoter />
          </Route>
          <Route exact path="/government/driving-license/admin-2-wheeler">
            <AdminWheeler2 />
          </Route>
          <Route exact path="/government/driving-license/2-wheeler">
            <NAdminWheeler2 />
          </Route>
          <Route exact path="/government/driving-license/admin-4-wheeler">
            <AdminWheeler4 />
          </Route>
          <Route exact path="/government/driving-license/4-wheeler">
            <NAdminWheeler4 />
          </Route>
          {/* Education */}
          <Route exact path="/education/engineering/admin-iiitnr">
            <AdminIIITNR />
          </Route>
          <Route exact path="/education/engineering/iiitnr">
            <NAdminIIITNR />
          </Route>
          <Route exact path="/education/others/admin-coursera">
            <AdminCoursera />
          </Route>
          <Route exact path="/education/others/coursera">
            <NAdminCoursera />
          </Route>
          {/* Healthcare */}
          <Route exact path="/admin-healthcare">
            <AdminHealthcare />
          </Route>
          <Route exact path="/healthcare">
            <NAdminHealthcare />
          </Route>
          {/* Finance */}
          <Route exact path="/finance">
            <Finance />
          </Route>
          {/* NFTs */}
          <Route exact path="/nft">
            <Nft />
          </Route>
        </Switch>
      </Router>
    </div>
  );
}

export default App;
