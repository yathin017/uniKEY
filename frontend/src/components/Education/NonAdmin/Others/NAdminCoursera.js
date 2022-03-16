import React from "react";
import Button from "react-bootstrap/Button";
import { Link } from "react-router-dom";

export default function NAdminCoursera() {
  return (
    <div>
      <Link to="/education/others/admin-coursera">
        <Button variant="warning">Admin Panel</Button>
      </Link>
      <br />
      NAdminCoursera
    </div>
  );
}
