<?php

namespace App\Command;

use MongoDB\Database;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:mongodb:ping',
    description: 'Vérifie la connexion à MongoDB',
)]
class MongodbPingCommand
{
    public function __construct(
        private readonly Database $database,
    ) {
    }

    public function __invoke(SymfonyStyle $io): int
    {
        try {
            $this->database->command(['ping' => 1]);
        } catch (\Throwable $e) {
            $io->error('Connexion à MongoDB impossible : ' . $e->getMessage());

            return Command::FAILURE;
        }

        $io->success('Connexion à MongoDB réussie.');

        return Command::SUCCESS;
    }
}