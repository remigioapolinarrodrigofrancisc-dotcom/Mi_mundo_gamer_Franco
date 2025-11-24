<?php
include 'config.php';
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>La redencion_FRANCO</title>
  <link rel="stylesheet" href="estilos.css">
</head>
<body>
<?php include 'menu.php'; ?>

<div class="container">
  <div class="card">
    <div style="display:flex;justify-content:space-between;align-items:center">
      <h2>RED DEAD REDEMPTION</h2>
      <img src="c:\mi_sitio_videjuegos\red-dead-redemption-2-img.jpg" alt="c:\mi_sitio_videjuegos\red-dead-redemption-2-img.jpg">
      <a class="btn primary" href="nuevo.php">+ Nuevo registro</a>
    </div>

    <?php
    $sql = "SELECT v.id_venta, v.fecha, v.monto, v.estado,
                   p.nombre AS producto, c.nombre AS cliente
            FROM ventas v
            JOIN productos p ON v.id_producto = p.id_producto
            JOIN clientes c ON v.id_cliente = c.id_cliente
            ORDER BY v.id_venta DESC";
    $stmt = $pdo->query($sql);
    $ventas = $stmt->fetchAll();
    ?>

    <?php if(!$ventas): ?>
      <div class="empty">No hay ventas registradas.</div>
    <?php else: ?>
      <table class="table">
        <thead>
          <tr><th>ID</th><th>Fecha</th><th>Monto</th><th>Producto</th><th>Cliente</th><th>Estado</th><th>Acciones</th></tr>
        </thead>
        <tbody>
        <?php foreach($ventas as $v): ?>
          <tr>
            <td><?= htmlspecialchars($v['id_venta']) ?></td>
            <td><?= htmlspecialchars($v['fecha']) ?></td>
            <td>$<?= number_format($v['monto'],2) ?></td>
            <td><?= htmlspecialchars($v['producto']) ?></td>
            <td><?= htmlspecialchars($v['cliente']) ?></td>
            <td><?= htmlspecialchars($v['estado']) ?></td>
            <td>
              <a class="btn ghost" href="editar.php?id=<?= $v['id_venta'] ?>">Editar</a>
              <a class="btn ghost" href="eliminar.php?id=<?= $v['id_venta'] ?>" onclick="return confirm('Eliminar venta?')">Eliminar</a>
            </td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    <?php endif; ?>
  </div>
</div>

</body>
</html>

