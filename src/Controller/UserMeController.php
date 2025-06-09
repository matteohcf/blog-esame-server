<?php
namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Bundle\SecurityBundle\Security;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class UserMeController extends AbstractController
{
    #[Route('/api/users/me', name: 'user_me', methods: ['GET'])]
    public function me(Security $security): JsonResponse
    {
        $user = $security->getUser();

        if (!$user) {
            return $this->json(['error' => 'Unauthorized'], 401);
        }

        return $this->json([
            'id' => $user->getId(),
            '_id' => $user->getId(),
            'email' => $user->getEmail(),
//            'roles' => $user->getRoles(),
        ]);
    }
}
